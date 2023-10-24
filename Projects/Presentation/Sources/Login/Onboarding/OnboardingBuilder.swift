//
//  OnboardingBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/08/07.
//

import Foundation
import UIKit

import Domain
import PBAnalyticsInterface
import PresentationInterface

struct OnboardingDependency {
  let analytics: PBAnalytics
  let mainTabBuilder: MainTabBarBuildable
}

final class OnboardingBuilder: OnboardingBuildable {

  private let dependency: OnboardingDependency

  init(dependency: OnboardingDependency) {
    self.dependency = dependency
  }

  func build(payload: OnboardingPayload) -> UIViewController {
    let reactor = OnboardingViewReactor(
      analytics: dependency.analytics
    )

    let viewController = OnboardingViewController(
      reactor: reactor,
      mainTabBuilder: dependency.mainTabBuilder
    )

    return viewController
  }
}
