//
//  FolderBuildable.swift
//  Presentation
//
//  Created by 박천송 on 2023/05/19.
//

import Foundation
import UIKit

import Domain

// MARK: - FolderBuildable

public protocol FolderBuildable {
  func build(payload: FolderPayload) -> UIViewController
}

// MARK: - FolderPayload

public struct FolderPayload {
  public init() {}
}
