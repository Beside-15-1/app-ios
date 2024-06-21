//
//  HomeFeedBuilder.swift
//  Presentation
//
//  Created by 박천송 on 6/21/24.
//

import UIKit
import Foundation

import Domain
import PresentationInterface

struct HomeFeedDependency {}

final class HomeFeedBuilder: HomeFeedBuildable {

  private let dependency: HomeFeedDependency

  init(dependency: HomeFeedDependency) {
    self.dependency = dependency
  }

  func build(payload: HomeFeedPayload) -> UIViewController {
    let reactor = HomeFeedViewReactor()

    let viewController = HomeFeedViewController(
      reactor: reactor
    )

    return viewController
  }
}
