//
//  EditFolderDelegate.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/14.
//

import Foundation

import Domain

public protocol EditFolderDelegate: AnyObject {
  func editFolderModifyButtonTapped(withFolder folder: Folder)
  func editFolderDeleteButtonTapped(withFolder folder: Folder)
}
