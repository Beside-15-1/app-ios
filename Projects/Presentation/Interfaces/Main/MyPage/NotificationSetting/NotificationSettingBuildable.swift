//
//  NotificationSettingBuildable.swift
//  Presentation
//
//  Created by 박천송 on 10/24/23.
//

import Foundation
import UIKit

import Domain

public protocol NotificationSettingBuildable {

  func build(payload: NotificationSettingPayload) -> UIViewController
}

public struct NotificationSettingPayload {
  public init() {}
}
