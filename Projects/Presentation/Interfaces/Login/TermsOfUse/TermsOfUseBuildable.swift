import Foundation
import UIKit

import Domain

// MARK: - TermsOfUseBuildable

public protocol TermsOfUseBuildable {
  func build(payload: TermsOfUsePayload) -> UIViewController
}

// MARK: - TermsOfUsePayload

public struct TermsOfUsePayload {
  public let delegate: TermsOfUseDelegate?

  public init(
    delegate: TermsOfUseDelegate?
  ) {
    self.delegate = delegate
  }
}
