//
//  LinkDetailBuildable.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/18.
//

import Foundation
import UIKit

import Domain

public protocol LinkDetailBuildable {

  func build(payload: LinkDetailPayload) -> UIViewController
}

public struct LinkDetailPayload {

  public let link: Link

  public init(
    link: Link
  ) {
    self.link = link
  }
}
