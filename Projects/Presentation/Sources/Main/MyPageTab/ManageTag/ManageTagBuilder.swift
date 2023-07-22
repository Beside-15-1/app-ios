//
//  ManageTagBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/22.
//

import UIKit
import Foundation

import Domain
import PresentationInterface

struct ManageTagDependency {}

final class ManageTagBuilder: ManageTagBuildable {

  private let dependency: ManageTagDependency

  init(dependency: ManageTagDependency) {
    self.dependency = dependency
  }

  func build(payload: ManageTagPayload) -> UIViewController {
    let reactor = ManageTagViewReactor(
      userDefaults: .shared
    )

    let viewController = ManageTagViewController(
      reactor: reactor
    )

    return viewController
  }
}
