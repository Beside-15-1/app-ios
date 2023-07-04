//
//  SelectFolderBuildable.swift
//  PresentationInterface
//
//  Created by 박천송 on 2023/07/04.
//

import Foundation
import UIKit

import Domain

public protocol SelectFolderBuildable {

  func build(payload: SelectFolderPayload) -> UIViewController
}

public struct SelectFolderPayload {

  public let folders: [Folder]
  public let selectedFolder: Folder
  public let delegate: SelectFolderDelegate?

  public init(
    folders: [Folder],
    selectedFolder: Folder,
    delegate: SelectFolderDelegate?
  ) {
    self.folders = folders
    self.selectedFolder = selectedFolder
    self.delegate = delegate
  }
}
