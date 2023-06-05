import Foundation

import RxRelay
import RxSwift
import UIKit

import AuthenticationServices
import Domain
import PBAnalyticsInterface

// MARK: - LoginViewModelInput

protocol LoginViewModelInput {
  func googleLoginButtonTapped()
  func appleLoginButtonTapped()
}

// MARK: - LoginViewModelOutput

protocol LoginViewModelOutput {
  var isLoginSuccess: BehaviorRelay<Bool> { get }
  var error: BehaviorRelay<Error?> { get }
}

// MARK: - LoginViewModel

final class LoginViewModel: LoginViewModelOutput {
  private let analytics: PBAnalytics
  private let loginManager: LoginManagerProtocol
  private let googleLoginUseCase: GoogleLoginUseCase
  private let appleLoginUseCase: AppleLoginUseCase

  private let disposeBag = DisposeBag()

  init(
    analytics: PBAnalytics,
    loginManager: LoginManagerProtocol,
    googleLoginUseCase: GoogleLoginUseCase,
    appleLoginUseCase: AppleLoginUseCase
  ) {
    self.analytics = analytics
    self.loginManager = loginManager
    self.googleLoginUseCase = googleLoginUseCase
    self.appleLoginUseCase = appleLoginUseCase
  }

  var isLoginSuccess: BehaviorRelay<Bool> = .init(value: false)
  var error: BehaviorRelay<Error?> = .init(value: nil)
}

// MARK: LoginViewModelInput

extension LoginViewModel: LoginViewModelInput {
  func googleLoginButtonTapped() {
    analytics.log(type: LoginEvent.clickGoogleLogin)

    loginManager.login(with: .google)
  }

  func appleLoginButtonTapped() {
    analytics.log(type: LoginEvent.clickAppleLogin)

    loginManager.login(with: .apple)
  }
}

// MARK: LoginManagerDelegate

extension LoginViewModel: LoginManagerDelegate {
  func loginManager(_ type: SocialLogin, didSucceedWithResult result: [String: String]) {
    // TODO: token to server
    switch type {
    case .google:
      guard let access = result["accessToken"] else { return }

      googleLoginUseCase.excute(access: access)
        .subscribe(onSuccess: { [weak self] canLogin in
          guard let self else { return }
          if canLogin {
            self.isLoginSuccess.accept(true)
          } else {
            self.needSignUp.accept((access, "google"))
          }

        }, onFailure: { [weak self] error in
          self?.error.accept(error)
        })
        .disposed(by: disposeBag)

    case .apple:
      guard let identity = result["identityToken"] else { return }

      appleLoginUseCase.excute(identity: identity)
        .subscribe(onSuccess: { [weak self] canLogin in
          guard let self else { return }

          if canLogin {
            self.isLoginSuccess.accept(true)
          } else {
            self.needSignUp.accept((identity, "apple"))
          }

        }, onFailure: { [weak self] error in
          self?.error.accept(error)
        })
        .disposed(by: disposeBag)
    }
  }

  func loginManager(didFailWithError error: Error) {
    // TODO: fail alert
    self.error.accept(error)
  }
}
