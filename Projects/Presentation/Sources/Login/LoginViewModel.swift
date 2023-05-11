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
import LoginManagerInterface

// MARK: - LoginViewModelInput

protocol LoginViewModelInput {
  func appleLoginButtonTapped()
  func googleLoginButtonTapped()
}

// MARK: - LoginViewModelOutput

protocol LoginViewModelOutput {}

// MARK: - LoginViewModel

final class LoginViewModel {
  private let loginManager: LoginManager
  private let guideUseCase: GuideUseCase

  private let disposeBag = DisposeBag()

  init(
    loginManager: LoginManager,
    guideUseCase: GuideUseCase
  ) {
    self.loginManager = loginManager
    self.guideUseCase = guideUseCase
  }
}

// MARK: LoginViewModelInput

extension LoginViewModel: LoginViewModelInput {
  func googleLoginButtonTapped() {
    loginManager.login(with: .google)
      .subscribe(onSuccess: { token in
        // TODO: 서버에 토큰 보내기
        print(token)
      }, onFailure: { error in
        // TODO: 알럿 띄워주기
        print(error)
      })
      .disposed(by: disposeBag)
  }
  func appleLoginButtonTapped() {
    guard let loginViewController else { return }

    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]

    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = loginViewController
    authorizationController.presentationContextProvider = loginViewController
    authorizationController.performRequests()
  }

  func validateAppleIdCredential(_ credential: ASAuthorizationAppleIDCredential) {
    guard let tokenData = credential.authorizationCode,
          let token = String(data: tokenData, encoding: .utf8),
          let identityToken = credential.identityToken,
          let identity = String(data: identityToken, encoding: .utf8) else { return }

    provider.rx.request(.validateAppleUser(token: token, identity: identity))
      .subscribe { result in
        switch result {
        case let .success(response):
          print(response)
        case .failure:
          print("error")
        }
      }
      .disposed(by: disposeBag)
  }

  func handlePasswordCredential(_ credential: ASPasswordCredential) {
    let _ = credential.user
    let _ = credential.password
  }
}
