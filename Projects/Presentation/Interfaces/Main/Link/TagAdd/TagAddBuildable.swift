import Foundation
import UIKit

import Domain

// MARK: - TagAddBuildable

public protocol TagAddBuildable {
  func build(payload: TagAddPayload) -> UIViewController
}

// MARK: - TagAddPayload

public struct TagAddPayload {
  public let tagAddDelegate: TagAddDelegate?
  public let addedTagList: [String]

  public init(
    tagAddDelegate: TagAddDelegate?,
    addedTagList: [String]
  ) {
    self.tagAddDelegate = tagAddDelegate
    self.addedTagList = addedTagList
  }
}
