//
//  HomeBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/05.
//

import UIKit
import Foundation

import Domain
import PresentationInterface

struct HomeDependency {
  let createLinkBuilder: CreateLinkBuildable
}

final class HomeBuilder: HomeBuildable {

  private let dependency: HomeDependency

  init(dependency: HomeDependency) {
    self.dependency = dependency
  }

  func build(payload: HomePayload) -> UIViewController {
    let reactor = HomeViewReactor()

    let viewController = HomeViewController(
      reactor: reactor,
      createLinkBuilder: dependency.createLinkBuilder
    )

    return viewController
  }
}
