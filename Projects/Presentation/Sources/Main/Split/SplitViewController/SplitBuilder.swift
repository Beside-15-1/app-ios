//
//  SplitBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/08/24.
//

import Foundation
import UIKit

import Domain
import PresentationInterface

struct SplitDependency {
  let masterBuilder: MasterBuildable
  let mainTabBuilder: MainTabBarBuildable
  let loginBuilder: LoginBuildable
}

final class SplitBuilder: SplitBuildable {

  private let dependency: SplitDependency

  init(dependency: SplitDependency) {
    self.dependency = dependency
  }

  func build(payload: SplitPayload) -> UIViewController {
    let masterViewController = dependency.masterBuilder.build(payload: .init())

    let detailViewController: UIViewController
    if payload.isLogin {
      detailViewController = dependency.mainTabBuilder.build(payload: .init())
    } else {
      detailViewController = dependency.loginBuilder.build(payload: .init())
    }

    let split = SplitViewController(style: .doubleColumn).then {
      $0.setViewController(UINavigationController(rootViewController: masterViewController), for: .primary)
      $0.setViewController(UINavigationController(rootViewController: detailViewController), for: .secondary)
      $0.minimumPrimaryColumnWidth = 250
      $0.maximumPrimaryColumnWidth = 250
      $0.primaryBackgroundStyle = .sidebar
      $0.presentsWithGesture = false
      if payload.isLogin, UIDevice.current.userInterfaceIdiom == .pad {
        $0.preferredDisplayMode = .oneBesideSecondary
      } else {
        $0.preferredDisplayMode = .automatic
      }
    }

    return split
  }
}
