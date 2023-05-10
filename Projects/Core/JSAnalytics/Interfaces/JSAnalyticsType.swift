//
//  JSAnalyticsType.swift
//  JSAnalyticsInterface
//
//  Created by 박천송 on 2023/05/11.
//

import Foundation

public protocol JSAnalyticsType {
  var name: String { get }
  var parameters: [String: Any]? { get }
}
