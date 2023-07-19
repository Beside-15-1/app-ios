//
//  MoveFolderDelegate.swift
//  PresentationInterface
//
//  Created by 박천송 on 2023/07/19.
//

import Foundation

import Domain

public protocol MoveFolderDelegate: AnyObject {
  func moveFolderSuccess(folder: Folder)
}
