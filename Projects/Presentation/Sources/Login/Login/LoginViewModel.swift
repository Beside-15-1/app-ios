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
  func termsOfUseNextButtonTapped()
}

// MARK: - LoginViewModelOutput

protocol LoginViewModelOutput {
  var isLoginSuccess: BehaviorRelay<Bool> { get }
  var showTermsOfUse: BehaviorRelay<Bool> { get }
  var needSignUp: PublishRelay<(String, String)> { get }
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
  var showTermsOfUse: BehaviorRelay<Bool> = .init(value: false)
  var needSignUp: PublishRelay<(String, String)> = .init()
  var error: BehaviorRelay<Error?> = .init(value: nil)

  private var idToken: String = ""
  private var latestSocialLogin = ""
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

  func termsOfUseNextButtonTapped() {
    guard !idToken.isEmpty, !latestSocialLogin.isEmpty else { return }

    needSignUp.accept((idToken, latestSocialLogin))
  }
}

// MARK: LoginManagerDelegate

extension LoginViewModel: LoginManagerDelegate {
  func loginManager(_ type: SocialLogin, didSucceedWithResult result: [String: String]) {
    // TODO: token to server
    switch type {
    case .google:
      guard let idToken = result["identityToken"] else { return }

      self.idToken = idToken
      latestSocialLogin = "google"

      googleLoginUseCase.execute(access: idToken)
        .subscribe(onSuccess: { [weak self] canLogin in
          guard let self else { return }
          if canLogin {
            self.isLoginSuccess.accept(true)
          } else {
            self.showTermsOfUse.accept(true)
          }

        }, onFailure: { [weak self] error in
          self?.error.accept(error)
        })
        .disposed(by: disposeBag)

    case .apple:
      guard let idToken = result["identityToken"] else { return }

      self.idToken = idToken
      latestSocialLogin = "apple"

      appleLoginUseCase.execute(identity: idToken)
        .subscribe(onSuccess: { [weak self] canLogin in
          guard let self else { return }

          if canLogin {
            self.isLoginSuccess.accept(true)
          } else {
            self.showTermsOfUse.accept(true)
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
