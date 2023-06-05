import Foundation
import UIKit

import Domain

// MARK: - MyPageBuildable

public protocol MyPageBuildable {
  func build(payload: MyPagePayload) -> UIViewController
  func configure(loginBuilder: LoginBuildable)
}

// MARK: - MyPagePayload

public struct MyPagePayload {
  public init() {}
}
