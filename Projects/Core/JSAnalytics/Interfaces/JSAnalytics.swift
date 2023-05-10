//
//  JSAnalytics.swift
//  JSAnalyticsInterface
//
//  Created by 박천송 on 2023/05/10.
//

import Foundation

import FirebaseAnalytics

// MARK: - JSAnalytics

public protocol JSAnalytics {
  func log(type: JSAnalyticsType)
}

// MARK: - FirebaseAnalyticsProtocol

public protocol FirebaseAnalyticsProtocol {
  static func logEvent(_ name: String, parameters: [String: Any]?)
}

// MARK: - FirebaseAnalytics.Analytics + FirebaseAnalyticsProtocol

extension FirebaseAnalytics.Analytics: FirebaseAnalyticsProtocol {}
