//
//  PBWebBuildable.swift
//  PresentationInterface
//
//  Created by 박천송 on 2023/07/22.
//

import Foundation
import UIKit

/// @mockable
public protocol PBWebBuildable {
  func build(payload: PBWebPayload) -> UIViewController
}

// MARK: - LoginPayload

public struct PBWebPayload {

  public let url: URL

  public init(
    url: URL
  ) {
    self.url = url
  }
}
