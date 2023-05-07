//
//  LoginViewModel.swift
//  PresentationInterface
//
//  Created by 박천송 on 2023/04/27.
//

import Foundation

import RxMoya
import RxSwift
import UIKit

import AuthenticationServices
import Domain
import Networking

// MARK: - LoginViewModelInput

protocol LoginViewModelInput {
  func appleLoginButtonTapped()
}

// MARK: - LoginViewModelOutput

protocol LoginViewModelOutput {}

// MARK: - LoginViewModel

final class LoginViewModel {
  private let guideUseCase: GuideUseCase

  weak var loginViewController: LoginViewController?

  private let disposeBag = DisposeBag()

  init(guideUseCase: GuideUseCase) {
    self.guideUseCase = guideUseCase
  }
}

// MARK: LoginViewModelInput

extension LoginViewModel: LoginViewModelInput {
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
