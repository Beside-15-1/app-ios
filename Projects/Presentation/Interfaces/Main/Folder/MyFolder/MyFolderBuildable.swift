//
//  MyFolderBuildable.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/11.
//

import Foundation
import UIKit

import Domain

public protocol MyFolderBuildable {

  func build(payload: MyFolderPayload) -> UIViewController
}

public struct MyFolderPayload {
  public init() {}
}
