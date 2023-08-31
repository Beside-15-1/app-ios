//
//  MasterDelegate.swift
//  PresentationInterface
//
//  Created by 박천송 on 2023/08/30.
//

import Foundation

public protocol MasterDelegate: AnyObject {
  func masterHomeTapped()
  func masterFolderTapped()
  func masterMyPageTapped()
}
