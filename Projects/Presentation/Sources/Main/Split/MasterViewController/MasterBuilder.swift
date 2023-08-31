//
//  MasterBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/08/28.
//

import UIKit
import Foundation

import Domain
import PresentationInterface

struct MasterDependency {}

final class MasterBuilder: MasterBuildable {

  private let dependency: MasterDependency

  init(dependency: MasterDependency) {
    self.dependency = dependency
  }

  func build(payload: MasterPayload) -> UIViewController {
    let reactor = MasterViewReactor()

    let viewController = MasterViewController(
      reactor: reactor
    ).then {
      $0.delegate = payload.delegate
    }

    return viewController
  }
}
