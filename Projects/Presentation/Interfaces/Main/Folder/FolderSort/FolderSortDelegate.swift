//
//  FolderSortDelegate.swift
//  PresentationInterface
//
//  Created by 박천송 on 2023/07/16.
//

import Foundation

public protocol FolderSortDelegate: AnyObject {
  func folderSortListItemTapped(type: FolderSortModel)
}
