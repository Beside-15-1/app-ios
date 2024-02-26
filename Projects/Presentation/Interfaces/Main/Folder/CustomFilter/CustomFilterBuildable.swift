//
//  CustomFilterBuildable.swift
//  Presentation
//
//  Created by 박천송 on 12/20/23.
//

import Foundation
import UIKit

import Domain

public protocol CustomFilterBuildable {

  func build(payload: CustomFilterPayload) -> UIViewController
}

public struct CustomFilterPayload {

  public let customFilter: CustomFilter?
  public let delegate: CustomFilterDelegate?

  public init(
    customFilter: CustomFilter?,
    delegate: CustomFilterDelegate?
  ) {
    self.customFilter = customFilter
    self.delegate = delegate
  }
}
