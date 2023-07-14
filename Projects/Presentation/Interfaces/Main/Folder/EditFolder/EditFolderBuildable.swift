//
//  EditFolderBuildable.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/14.
//

import Foundation
import UIKit

import Domain

public protocol EditFolderBuildable {

  func build(payload: EditFolderPayload) -> UIViewController
}

public struct EditFolderPayload {

  public let delegate: EditFolderDelegate?
  public let folder: Folder

  public init(
    delegate: EditFolderDelegate?,
    folder: Folder
  ) {
    self.delegate = delegate
    self.folder = folder
  }
}
