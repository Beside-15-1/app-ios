import Foundation
import UIKit

import Domain
import PBAnalyticsInterface
import PresentationInterface

// MARK: - SignUpDependency

struct SignUpDependency {
  let analytics: PBAnalytics
  let loginRepository: LoginRepository
  let mainTabBuilder: MainTabBarBuildable
  let signUpSuccessBuilder: SingUpSuccessBuildable
  let onboardingBuilder: OnboardingBuildable
}

// MARK: - SignUpBuilder

final class SignUpBuilder: SignUpBuildable {
  private let dependency: SignUpDependency

  init(dependency: SignUpDependency) {
    self.dependency = dependency
  }

  func build(payload: SignUpPayload) -> UIViewController {
    let reactor = SignUpViewReactor(
      analytics: dependency.analytics,
      signUpUseCase: SignUpUseCaseImpl(loginRepository: dependency.loginRepository),
      accessToken: payload.accessToken,
      social: payload.social
    )

    let viewController = SignUpViewController(
      reactor: reactor,
      analytics: dependency.analytics,
      mainTabBuilder: dependency.mainTabBuilder,
      signUpSuccessBuilder: dependency.signUpSuccessBuilder,
      onboardingBuilder: dependency.onboardingBuilder
    )

    return viewController
  }
}
