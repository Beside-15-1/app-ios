import Foundation

import UIKit

import Domain
import PBAnalyticsInterface
import PresentationInterface

// MARK: - LoginDependency

struct LoginDependency {
  let analytics: PBAnalytics
  let loginRepository: LoginRepository
  let tagRepository: TagRepository
  let mainTabBuilder: MainTabBarBuildable
  let signUpBuilder: SignUpBuildable
  let termsOfUseBuilder: TermsOfUseBuildable
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
      analytics: dependency.analytics,
      loginManager: loginManager,
      googleLoginUseCase: GoogleLoginUseCaseImpl(
        loginRepository: dependency.loginRepository,
        tagRepository: dependency.tagRepository
      ),
      appleLoginUseCase: AppleLoginUseCaseImpl(
        loginRepository: dependency.loginRepository,
        tagRepository: dependency.tagRepository
      )
    )

    let viewController = LoginViewController(
      viewModel: viewModel,
      mainTabBuilder: dependency.mainTabBuilder,
      signUpBuilder: dependency.signUpBuilder,
      termsOfUseBuilder: dependency.termsOfUseBuilder
    )
    loginManager.viewController = viewController
    loginManager.delegate = viewModel

    return viewController
  }
}
