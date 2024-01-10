//
//  TagAndPeriodFilterBuilder.swift
//  Presentation
//
//  Created by 박천송 on 12/20/23.
//

import Foundation
import UIKit

import Domain
import PBUserDefaults
import PresentationInterface

struct TagAndPeriodFilterDependency {}

final class TagAndPeriodFilterBuilder: TagAndPeriodFilterBuildable {

  private let dependency: TagAndPeriodFilterDependency

  init(dependency: TagAndPeriodFilterDependency) {
    self.dependency = dependency
  }

  func build(payload: TagAndPeriodFilterPayload) -> UIViewController {
    let reactor = TagAndPeriodFilterViewReactor(
      userDefaults: .shared
    )

    let viewController = TagAndPeriodFilterViewController(
      reactor: reactor
    )

    return viewController
  }
}
