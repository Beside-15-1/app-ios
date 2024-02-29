//
//  CustomFilterBuilder.swift
//  Presentation
//
//  Created by 박천송 on 12/20/23.
//

import Foundation
import UIKit

import Domain
import PresentationInterface

struct CustomFilterDependency {
  let tagRepository: TagRepository
}

final class CustomFilterBuilder: CustomFilterBuildable {

  private let dependency: CustomFilterDependency

  init(dependency: CustomFilterDependency) {
    self.dependency = dependency
  }

  func build(payload: CustomFilterPayload) -> UIViewController {
    let reactor = CustomFilterViewReactor(
      tagRepository: dependency.tagRepository,
      customFilter: payload.customFilter
    )

    let viewController = CustomFilterViewController(
      reactor: reactor
    ).then {
      $0.delegate = payload.delegate
    }

    return viewController
  }
}
