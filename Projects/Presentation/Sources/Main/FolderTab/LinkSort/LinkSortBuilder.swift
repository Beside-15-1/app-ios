//
//  LinkSortBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/18.
//

import UIKit
import Foundation

import Domain
import PresentationInterface

struct LinkSortDependency {}

final class LinkSortBuilder: LinkSortBuildable {

  private let dependency: LinkSortDependency

  init(dependency: LinkSortDependency) {
    self.dependency = dependency
  }

  func build(payload: LinkSortPayload) -> UIViewController {
    let reactor = LinkSortViewReactor(
      sortType: payload.sortType
    )

    let viewController = LinkSortViewController(
      reactor: reactor
    ).then {
      $0.delegate = payload.delegate
    }

    return viewController
  }
}
