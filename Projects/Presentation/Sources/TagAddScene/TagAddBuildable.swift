import Foundation
import UIKit

import Domain

// MARK: - TagAddBuildable

public protocol TagAddBuildable {
  func build(payload: TagAddPayload) -> UIViewController
}

// MARK: - TagAddPayload

public struct TagAddPayload {
  public init() {}
}
