//
//  AppAssembly.swift
//  App
//
//  Created by 박천송 on 2023/04/27.
//

import Foundation
import UIKit

import FirebaseCore
import Swinject

import Data
import PBAnalytics
import PBAuth
import PBAuthInterface
import Presentation
import PresentationInterface

// MARK: - AppDependency

struct AppDependency {
  let rootViewController: UIViewController

  let configureFirebase: () -> Void
}

// MARK: - AppAssembly

enum AppAssembly {
  static let container: Container = .init(defaultObjectScope: .container)

  static func resolve() -> AppDependency {
    let assemblies: [Assembly] = [
      DataAssembly(),
      PresentationAssembly(),
      PBAnalyticsAssembly(),
      PBAuthAssembly()
    ]

    _ = Assembler(assemblies, container: container)
    let resolver = container

    let rootViewController = UINavigationController()
    let localDataSource = resolver.resolve(PBAuthLocalDataSource.self)!

    var vc: UIViewController {
      if let accessToken = localDataSource.accessToken,
         !accessToken.isEmpty {
        return resolver.resolve(MainTabBarBuildable.self)!.build(payload: .init())
      } else {
        return resolver.resolve(LoginBuildable.self)!.build(payload: .init())
      }
    }
    rootViewController.setViewControllers([vc], animated: false)

    return AppDependency(
      rootViewController: rootViewController,
      configureFirebase: {
        configureFirebase()
      }
    )
  }
}

extension AppAssembly {
  static func configureFirebase() {
    FirebaseApp.configure()
  }
}
