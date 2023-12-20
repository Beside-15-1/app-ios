//
//  TagAndPeriodFilterBuildable.swift
//  Presentation
//
//  Created by 박천송 on 12/20/23.
//

import Foundation
import UIKit

import Domain

public protocol TagAndPeriodFilterBuildable {

  func build(payload: TagAndPeriodFilterPayload) -> UIViewController
}

public struct TagAndPeriodFilterPayload {
  public init() {}
}
