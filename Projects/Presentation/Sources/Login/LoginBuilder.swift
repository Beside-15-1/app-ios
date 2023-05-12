//
//  LoginBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/04/27.
//

import Foundation

import UIKit

import Domain
import PresentationInterface

// MARK: - LoginDependency

struct LoginDependency {
  let guideRepository: GuideRepository
}

// MARK: - LoginBuilder

final class LoginBuilder: LoginBuildable {
  private let dependency: LoginDependency

  init(dependency: LoginDependency) {
    self.dependency = dependency
  }

  func build(payload: LoginPayload) -> UIViewController {
    let loginManager = LoginManager()

    let viewModel = LoginViewModel(
      loginManager: loginManager,
      guideUseCase: GuideUseCaseImpl(guideRepository: dependency.guideRepository)
    )

    let viewController = LoginViewController(viewModel: viewModel)
    loginManager.viewController = viewController

    return viewController
  }
}
