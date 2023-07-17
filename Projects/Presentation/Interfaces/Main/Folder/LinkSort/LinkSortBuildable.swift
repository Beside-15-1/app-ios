//
//  LinkSortBuildable.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/18.
//

import Foundation
import UIKit

import Domain

public protocol LinkSortBuildable {

  func build(payload: LinkSortPayload) -> UIViewController
}

public struct LinkSortPayload {

  public let delegate: LinkSortDelegate?
  public let sortType: LinkSortingType

  public init(
    delegate: LinkSortDelegate?,
    sortType: LinkSortingType
  ) {
    self.delegate = delegate
    self.sortType = sortType
  }
}
