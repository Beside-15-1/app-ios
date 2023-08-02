//
//  FolderDetailBuildable.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/17.
//

import Foundation
import UIKit

import Domain

public protocol FolderDetailBuildable {

  func build(payload: FolderDetailPayload) -> UIViewController
}

public struct FolderDetailPayload {

  public let folderList: [Folder]
  public let selectedFolder: Folder

  public init(
    folderList: [Folder],
    selectedFolder: Folder
  ) {
    self.folderList = folderList
    self.selectedFolder = selectedFolder
  }
}
