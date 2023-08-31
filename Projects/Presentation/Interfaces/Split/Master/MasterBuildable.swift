//
//  MasterBuildable.swift
//  Presentation
//
//  Created by 박천송 on 2023/08/28.
//

import Foundation
import UIKit

import Domain

public protocol MasterBuildable {

  func build(payload: MasterPayload) -> UIViewController
}

public struct MasterPayload {

  public let delegate: MasterDelegate?

  public init(
    delegate: MasterDelegate?
  ) {
    self.delegate = delegate
  }
}
