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

  public init(
    delegate: CreateLinkDelegate?,
    link: Link?
  ) {
    self.delegate = delegate
    self.link = link
  }
}
