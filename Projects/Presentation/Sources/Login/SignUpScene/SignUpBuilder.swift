import Foundation
import UIKit

import Domain
import PresentationInterface

// MARK: - SignUpDependency

struct SignUpDependency {
  let loginRepository: LoginRepository
  let mainTabBuilder: MainTabBarBuildable
}

// MARK: - SignUpBuilder

final class SignUpBuilder: SignUpBuildable {
  private let dependency: SignUpDependency

  init(dependency: SignUpDependency) {
    self.dependency = dependency
  }

  func build(payload: SignUpPayload) -> UIViewController {
    let viewModel = SignUpViewModel(
      signUpUseCase: SignUpUseCaseImpl(loginRepository: dependency.loginRepository),
      accessToken: payload.accessToken,
      social: payload.social
    )

    let viewController = SignUpViewController(
      viewModel: viewModel,
      mainTabBuilder: dependency.mainTabBuilder
    )

    return viewController
  }
}
