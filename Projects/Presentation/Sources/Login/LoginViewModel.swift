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
  private let googleLoginUseCase: GoogleLoginUseCase
  private let appleLoginUseCase: AppleLoginUseCase

  private let disposeBag = DisposeBag()

  init(
    loginManager: LoginManager,
    googleLoginUseCase: GoogleLoginUseCase,
    appleLoginUseCase: AppleLoginUseCase
  ) {
    self.loginManager = loginManager
    self.googleLoginUseCase = googleLoginUseCase
    self.appleLoginUseCase = appleLoginUseCase
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
