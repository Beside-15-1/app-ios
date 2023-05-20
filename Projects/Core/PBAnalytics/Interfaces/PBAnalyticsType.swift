//
//  PBAnalyticsType.swift
//  PBAnalyticsInterface
//
//  Created by 박천송 on 2023/05/11.
//

import Foundation

public protocol PBAnalyticsType {
  var name: String { get }
  var parameters: [String: Any]? { get }
}
