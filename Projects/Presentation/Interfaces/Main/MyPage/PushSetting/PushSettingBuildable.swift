//
//  PushSettingBuildable.swift
//  Presentation
//
//  Created by 박천송 on 10/24/23.
//

import Foundation
import UIKit

import Domain

public protocol PushSettingBuildable {

  func build(payload: PushSettingPayload) -> UIViewController
}

public struct PushSettingPayload {
  public init() {}
}
