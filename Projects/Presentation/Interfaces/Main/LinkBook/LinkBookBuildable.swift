import Foundation
import UIKit

import Domain

// MARK: - CreateFolderBuildable

public protocol CreateFolderBuildable {
  func build(payload: CreateFolderPayload) -> UIViewController
}

// MARK: - CreateFolderPayload

public struct CreateFolderPayload {
  public init() {}
}
