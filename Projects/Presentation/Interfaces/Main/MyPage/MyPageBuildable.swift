//
//  MyPageBuildable.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/20.
//

import Foundation
import UIKit

import Domain

public protocol MyPageBuildable {

  func build(payload: MyPagePayload) -> UIViewController
  func configure(loginBuilder: LoginBuildable)
}

public struct MyPagePayload {
  public init() {}
}
