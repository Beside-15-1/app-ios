//
//  CreateFolderDelegate.swift
//  PresentationInterface
//
//  Created by 박천송 on 2023/07/07.
//

import Foundation

import Domain

public protocol CreateFolderDelegate: AnyObject {
  func createFolderSucceed(folder: Folder)
}
