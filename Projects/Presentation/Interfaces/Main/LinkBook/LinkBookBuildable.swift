import Foundation
import UIKit

import Domain

// MARK: - LinkBookBuildable

public protocol LinkBookBuildable {
  func build(payload: LinkBookPayload) -> UIViewController
}

// MARK: - LinkBookPayload

public struct LinkBookPayload {
  public init() {}
}
