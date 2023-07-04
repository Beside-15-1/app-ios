//
//  SelectFolderDelegate.swift
//  PresentationInterface
//
//  Created by 박천송 on 2023/07/04.
//

import Foundation

import Domain

public protocol SelectFolderDelegate: AnyObject {
  func selectFolderViewItemTapped(folder: Folder)
}
