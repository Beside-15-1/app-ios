//
//  FolderSortBuildable.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/16.
//

import Foundation
import UIKit

import Domain

public protocol FolderSortBuildable {

  func build(payload: FolderSortPayload) -> UIViewController
}

public struct FolderSortPayload {

  public let delegate: FolderSortDelegate?
  public let sortType: FolderSortModel

  public init(
    delegate: FolderSortDelegate?,
    sortType: FolderSortModel
  ) {
    self.delegate = delegate
    self.sortType = sortType
  }
}
