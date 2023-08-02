import Foundation
import UIKit

import Domain

// MARK: - HomeBuildable

public protocol HomeBuildable {
  func build(payload: HomePayload) -> UIViewController
}

// MARK: - HomePayload

public struct HomePayload {
  public init() {}
}
