//
//  LoginBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/04/27.
//

import Foundation

import UIKit

import Domain
import LoginManagerInterface
import PresentationInterface

// MARK: - LoginDependency

struct LoginDependency {
  let loginManager: LoginManager
  let guideRepository: GuideRepository
}

// MARK: - LoginBuilder

final class LoginBuilder: LoginBuildable {
  private let dependency: LoginDependency

  init(dependency: LoginDependency) {
    self.dependency = dependency
  }

  func build(payload: LoginPayload) -> UIViewController {
    let viewModel = LoginViewModel(
      loginManager: dependency.loginManager,
      guideUseCase: GuideUseCaseImpl(guideRepository: dependency.guideRepository)
    )

    let viewController = LoginViewController(viewModel: viewModel)
    viewModel.loginViewController = viewController

    return viewController
  }
}
