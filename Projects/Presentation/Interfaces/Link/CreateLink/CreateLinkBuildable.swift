import Foundation
import UIKit

import Domain

// MARK: - CreateLinkBuildable

public protocol CreateLinkBuildable {
  func build(payload: CreateLinkPayload) -> UIViewController
}

// MARK: - CreateLinkPayload

public struct CreateLinkPayload {
  public init() {}
}
