//
//  MoveFolderBuildable.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/19.
//

import Foundation
import UIKit

import Domain

public protocol MoveFolderBuildable {

  func build(payload: MoveFolderPayload) -> UIViewController
}

public struct MoveFolderPayload {

  public let delegate: MoveFolderDelegate?
  public let folderID: String

  public init(
    delegate: MoveFolderDelegate?,
    folderID: String
  ) {
    self.delegate = delegate
    self.folderID = folderID
  }
}
