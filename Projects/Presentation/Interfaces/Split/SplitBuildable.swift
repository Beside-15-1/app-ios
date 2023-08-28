//
//  SplitBuildable.swift
//  Presentation
//
//  Created by 박천송 on 2023/08/24.
//

import Foundation
import UIKit

import Domain

public protocol SplitBuildable {

  func build(payload: SplitPayload) -> UIViewController
}

public struct SplitPayload {

  public let isLogin: Bool

  public init(
    isLogin: Bool
  ) {
    self.isLogin = isLogin
  }
}
