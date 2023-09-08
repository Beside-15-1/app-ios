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
import ShareExtension

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
      PBAuthAssembly(),
    ]

    _ = Assembler(assemblies, container: container)
    let resolver = container

    let localDataSource = resolver.resolve(PBAuthLocalDataSource.self)!
    let isLogin = localDataSource.accessToken != nil && !(localDataSource.accessToken?.isEmpty ?? true) == true

    let rootViewController = resolver.resolve(SplitBuildable.self)!.build(payload: .init(
      isLogin: isLogin
    ))

    return AppDependency(
      rootViewController: rootViewController,
      configureFirebase: {
        FirebaseApp.configure()
      }
    )
  }
}
