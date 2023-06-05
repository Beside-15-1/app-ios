import Foundation
import UIKit

import Domain

// MARK: - FolderBuildable

public protocol FolderBuildable {
  func build(payload: FolderPayload) -> UIViewController
}

// MARK: - FolderPayload

public struct FolderPayload {
  public init() {}
}
