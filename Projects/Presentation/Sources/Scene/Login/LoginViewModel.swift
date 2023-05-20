//
//  LoginViewModel.swift
//  PresentationInterface
//
//  Created by 박천송 on 2023/04/27.
//

import Foundation

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

protocol LoginViewModelOutput {}

// MARK: - LoginViewModel

final class LoginViewModel {
  private let analytics: PBAnalytics
  private let loginManager: LoginManager
  private let googleLoginUseCase: GoogleLoginUseCase
  private let appleLoginUseCase: AppleLoginUseCase

  private let disposeBag = DisposeBag()

  init(
    analytics: PBAnalytics,
    loginManager: LoginManager,
    googleLoginUseCase: GoogleLoginUseCase,
    appleLoginUseCase: AppleLoginUseCase
  ) {
    self.analytics = analytics
    self.loginManager = loginManager
    self.googleLoginUseCase = googleLoginUseCase
    self.appleLoginUseCase = appleLoginUseCase
  }
}

// MARK: LoginViewModelInput

extension LoginViewModel: LoginViewModelInput {
  func googleLoginButtonTapped() {
    analytics.log(type: LoginEvent.clickGoogleLogin)

    loginManager.login(with: .google)
  }

  func appleLoginButtonTapped() {
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
        .subscribe(onSuccess: { _ in
          // 라우팅
        }, onFailure: { _ in
          // 알럿
        })
        .disposed(by: disposeBag)

    case .apple:
      guard let identity = result["identityToken"],
            let authorization = result["authorizationCode"] else { return }

      appleLoginUseCase.excute(
        identity: identity,
        authorization: authorization
      )
      .subscribe(onSuccess: { _ in
        // 라우팅
      }, onFailure: { _ in
        // 알럿
      })
      .disposed(by: disposeBag)
    }
  }

  func loginManager(didFailWithError error: Error) {
    // TODO: fail alert
  }
}
