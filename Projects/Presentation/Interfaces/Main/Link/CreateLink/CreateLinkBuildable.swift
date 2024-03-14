import Foundation
import UIKit

import Domain

// MARK: - CreateLinkBuildable

public protocol CreateLinkBuildable {
  func build(payload: CreateLinkPayload) -> UIViewController
}

// MARK: - CreateLinkPayload

public struct CreateLinkPayload {

  public let delegate: CreateLinkDelegate?
  public let link: Link?
  public let folder: Folder?

  public init(
    delegate: CreateLinkDelegate?,
    link: Link?,
    folder: Folder?
  ) {
    self.delegate = delegate
    self.link = link
    self.folder = folder
  }
}
