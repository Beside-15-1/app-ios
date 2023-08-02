import Foundation

import UIKit

import Domain

// MARK: - LoginBuildable

/// @mockable
public protocol LoginBuildable {
  func build(payload: LoginPayload) -> UIViewController
}

// MARK: - LoginPayload

public struct LoginPayload {
  public init() {}
}
