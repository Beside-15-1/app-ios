//
//  NotificationSettingBuilder.swift
//  Presentation
//
//  Created by 박천송 on 10/24/23.
//

import Foundation
import UIKit

import Domain
import PBAnalyticsInterface
import PresentationInterface

struct NotificationSettingDependency {
  let analytics: PBAnalytics
  let pushRepository: PushRepository
}

final class NotificationSettingBuilder: NotificationSettingBuildable {

  private let dependency: NotificationSettingDependency

  init(dependency: NotificationSettingDependency) {
    self.dependency = dependency
  }

  func build(payload: NotificationSettingPayload) -> UIViewController {
    let reactor = NotificationSettingViewReactor(
      analytics: dependency.analytics,
      pushRepository: dependency.pushRepository
    )

    let viewController = NotificationSettingViewController(
      reactor: reactor
    )

    return viewController
  }
}
