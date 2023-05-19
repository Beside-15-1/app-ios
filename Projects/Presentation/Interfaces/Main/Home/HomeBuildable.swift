//
//  HomeBuildable.swift
//  Presentation
//
//  Created by 박천송 on 2023/05/19.
//

import Foundation
import UIKit

import Domain

// MARK: - HomeBuildable

public protocol HomeBuildable {
  func build(payload: HomePayload) -> UIViewController
}

// MARK: - HomePayload

public struct HomePayload {
  public init() {}
}
