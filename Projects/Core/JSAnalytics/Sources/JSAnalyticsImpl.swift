//
//  JSAnalyticsImpl.swift
//  JSAnalytics
//
//  Created by 박천송 on 2023/05/10.
//

import Foundation

import JSAnalyticsInterface

final class JSAnalyticsImpl: JSAnalytics {
  private let firebaseAnalytics: FirebaseAnalyticsProtocol.Type

  init(
    firebaseAnalytics: FirebaseAnalyticsProtocol.Type
  ) {
    self.firebaseAnalytics = firebaseAnalytics
  }

  func log(type: JSAnalyticsType) {
    firebaseAnalytics.logEvent(type.name, parameters: type.parameters)
  }
}
