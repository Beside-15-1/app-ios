//
//  LoginViewModel.swift
//  PresentationInterface
//
//  Created by 박천송 on 2023/04/27.
//

import Foundation

import RxSwift
import UIKit

import Domain
import LoginManagerInterface

// MARK: - LoginViewModelInput

protocol LoginViewModelInput {
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
}
