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
}
