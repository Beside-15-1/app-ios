import Foundation
import UIKit

import Domain

// MARK: - CreateFolderBuildable

public protocol CreateFolderBuildable {
  func build(payload: CreateFolderPayload) -> UIViewController
}

// MARK: - CreateFolderPayload

public struct CreateFolderPayload {

  public let folder: Folder?
  public let delegate: CreateFolderDelegate?

  public init(
    folder: Folder?,
    delegate: CreateFolderDelegate?
  ) {
    self.folder = folder
    self.delegate = delegate
  }
}
