//
//  MainTabBarBuildable.swift
//  Presentation
//
//  Created by 박천송 on 2023/05/19.
//

import Foundation
import UIKit

import Domain

// MARK: - MainTabBarBuildable

public protocol MainTabBarBuildable {
  func build(payload: MainTabBarPayload) -> UITabBarController
}

// MARK: - MainTabBarPayload

public struct MainTabBarPayload {
  public init() {}
}
