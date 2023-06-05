import Foundation

import FirebaseAnalytics

// MARK: - PBAnalytics

/// @mockable
public protocol PBAnalytics {
  func log(type: PBAnalyticsType)
}

// MARK: - FirebaseAnalyticsProtocol

public protocol FirebaseAnalyticsProtocol {
  static func logEvent(_ name: String, parameters: [String: Any]?)
}

// MARK: - FirebaseAnalytics.Analytics + FirebaseAnalyticsProtocol

extension FirebaseAnalytics.Analytics: FirebaseAnalyticsProtocol {}
