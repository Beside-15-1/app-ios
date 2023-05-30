//
//  PBAuthLocalDataSource.swift
//  PBAuthInterface
//
//  Created by 박천송 on 2023/05/30.
//

import Foundation

// MARK: - PBAuthLocalDataSource

/// @mockable
public protocol PBAuthLocalDataSource {
  var accessToken: String? { get set }
  var refreshToken: String? { get set }
}
