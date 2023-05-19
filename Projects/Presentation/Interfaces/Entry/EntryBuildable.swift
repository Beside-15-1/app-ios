//
//  EntryBuildable.swift
//  Presentation
//
//  Created by 박천송 on 2023/05/19.
//

import Foundation
import UIKit

import Domain

// MARK: - EntryBuildable

public protocol EntryBuildable {
  func build(payload: EntryPayload) -> UIViewController
}

// MARK: - EntryPayload

public struct EntryPayload {
  public init() {}
}
