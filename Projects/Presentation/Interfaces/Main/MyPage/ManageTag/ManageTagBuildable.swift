//
//  ManageTagBuildable.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/22.
//

import Foundation
import UIKit

import Domain

public protocol ManageTagBuildable {

  func build(payload: ManageTagPayload) -> UIViewController
}

public struct ManageTagPayload {
  public init() {}
}
