//
//  MyPageBuildable.swift
//  Presentation
//
//  Created by 박천송 on 2023/05/19.
//

import Foundation
import UIKit

import Domain

// MARK: - MyPageBuildable

public protocol MyPageBuildable {
  func build(payload: MyPagePayload) -> UIViewController
}

// MARK: - MyPagePayload

public struct MyPagePayload {
  public init() {}
}
