//
//  FolderSortBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/16.
//

import Foundation
import UIKit

import Domain
import PBAnalyticsInterface
import PresentationInterface

struct FolderSortDependency {
  let analytics: PBAnalytics
}

final class FolderSortBuilder: FolderSortBuildable {

  private let dependency: FolderSortDependency

  init(dependency: FolderSortDependency) {
    self.dependency = dependency
  }

  func build(payload: FolderSortPayload) -> UIViewController {
    let reactor = FolderSortViewReactor(
      sortType: payload.sortType
    )

    let viewController = FolderSortViewController(
      reactor: reactor,
      analytics: dependency.analytics
    ).then {
      $0.delegate = payload.delegate
    }

    return viewController
  }
}
