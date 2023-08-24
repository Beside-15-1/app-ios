//
//  SplitBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/08/24.
//

import UIKit
import Foundation

import Domain
import PresentationInterface

struct SplitDependency {
  let mainTabBuilder: MainTabBarBuildable
  let loginBuilder: LoginBuildable
}

final class SplitBuilder: SplitBuildable {

  private let dependency: SplitDependency

  init(dependency: SplitDependency) {
    self.dependency = dependency
  }

  func build(payload: SplitPayload) -> UIViewController {

    let vc: UIViewController

    if payload.isLogin {
      vc = dependency.mainTabBuilder.build(payload: .init())
    } else {
      vc = dependency.loginBuilder.build(payload: .init())
    }

    let navigation = UINavigationController(rootViewController: vc)

    let primary = UIViewController().then {
      $0.view.backgroundColor = .red
    }

    let split = UISplitViewController(style: .doubleColumn).then {
      $0.setViewController(primary, for: .primary)
      $0.setViewController(navigation, for: .secondary)
      $0.minimumPrimaryColumnWidth = 200
      $0.maximumPrimaryColumnWidth = 200
      $0.primaryBackgroundStyle = .sidebar
      $0.presentsWithGesture = false

      if UIDevice.current.userInterfaceIdiom == .pad {
        $0.preferredDisplayMode = .oneBesideSecondary
      } else {
        $0.preferredDisplayMode = .secondaryOnly
      }
    }

    return split
  }
}
