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
  func googleLoginButtonTapped()
  func appleLoginButtonTapped()
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
  }

  func appleLoginButtonTapped() {
    loginManager.login(with: .apple)
  }
}

// MARK: LoginManagerDelegate

extension LoginViewModel: LoginManagerDelegate {
  func loginManager(didSucceedWithResult result: String) {
    // TODO: token to server
  }

  func loginManager(didFailWithError error: Error) {
    // TODO: fail alert
  }
}
