//
//  ManageTagBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/22.
//

import Foundation
import UIKit

import Domain
import PBAnalyticsInterface
import PresentationInterface

struct ManageTagDependency {
  let analytics: PBAnalytics
  let tagRepository: TagRepository
}

final class ManageTagBuilder: ManageTagBuildable {

  private let dependency: ManageTagDependency

  init(dependency: ManageTagDependency) {
    self.dependency = dependency
  }

  func build(payload: ManageTagPayload) -> UIViewController {
    let reactor = ManageTagViewReactor(
      analytics: dependency.analytics,
      tagRepository: dependency.tagRepository
    )

    let viewController = ManageTagViewController(
      reactor: reactor,
      analytics: dependency.analytics
    )

    return viewController
  }
}
