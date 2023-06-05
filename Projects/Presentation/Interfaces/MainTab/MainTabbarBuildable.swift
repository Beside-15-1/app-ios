import Foundation
import UIKit

import Domain

// MARK: - MainTabBarBuildable

public protocol MainTabBarBuildable {
  func build(payload: MainTabBarPayload) -> UITabBarController
}

// MARK: - MainTabBarPayload

public struct MainTabBarPayload {
  public init() {}
}
