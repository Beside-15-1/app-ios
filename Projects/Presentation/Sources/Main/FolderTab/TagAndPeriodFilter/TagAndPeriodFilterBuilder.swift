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
      userDefaults: .shared,
      periodType: payload.periodType
    )

    let viewController = TagAndPeriodFilterViewController(
      reactor: reactor
    ).then {
      $0.delegate = payload.delegate
    }

    return viewController
  }
}
