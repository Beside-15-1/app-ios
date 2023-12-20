//
//  PushSettingBuilder.swift
//  Presentation
//
//  Created by 박천송 on 10/24/23.
//

import Foundation
import UIKit

import Domain
import PBAnalyticsInterface
import PresentationInterface

struct PushSettingDependency {
  let analytics: PBAnalytics
  let pushRepository: PushRepository
}

final class PushSettingBuilder: PushSettingBuildable {

  private let dependency: PushSettingDependency

  init(dependency: PushSettingDependency) {
    self.dependency = dependency
  }

  func build(payload: PushSettingPayload) -> UIViewController {
    let reactor = PushSettingViewReactor(
      analytics: dependency.analytics,
      pushRepository: dependency.pushRepository
    )

    let viewController = PushSettingViewController(
      reactor: reactor
    )

    return viewController
  }
}
