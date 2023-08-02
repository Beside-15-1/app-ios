import Foundation
import UIKit

import Domain

// MARK: - SignUpBuildable

public protocol SignUpBuildable {
  func build(payload: SignUpPayload) -> UIViewController
}

// MARK: - SignUpPayload

public struct SignUpPayload {
  public let accessToken: String
  public let social: String

  public init(accessToken: String, social: String) {
    self.accessToken = accessToken
    self.social = social
  }
}
