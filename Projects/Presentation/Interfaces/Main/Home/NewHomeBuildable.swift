//
//  HomeFeedBuildable.swift
//  Presentation
//
//  Created by 박천송 on 6/21/24.
//

import Foundation
import UIKit

import Domain

public protocol HomeFeedBuildable {

  func build(payload: HomeFeedPayload) -> UIViewController
}

public struct HomeFeedPayload {
  public init() {}
}
