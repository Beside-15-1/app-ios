//
//  PushSettingBuilder.swift
//  Presentation
//
//  Created by 박천송 on 10/24/23.
//

import UIKit
import Foundation

import Domain
import PresentationInterface

struct PushSettingDependency {
  let pushRepository: PushRepository
}

final class PushSettingBuilder: PushSettingBuildable {

  private let dependency: PushSettingDependency

  init(dependency: PushSettingDependency) {
    self.dependency = dependency
  }

  func build(payload: PushSettingPayload) -> UIViewController {
    let reactor = PushSettingViewReactor(
      pushRepository: dependency.pushRepository
    )

    let viewController = PushSettingViewController(
      reactor: reactor
    )

    return viewController
  }
}
