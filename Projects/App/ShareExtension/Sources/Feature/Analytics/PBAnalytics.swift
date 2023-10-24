//
//  PBAnalytics.swift
//  ShareExtension
//
//  Created by 박천송 on 10/24/23.
//

import Foundation

import PBAnalyticsInterface

final class PBAnalyticsImpl: PBAnalytics {
  private let firebaseAnalytics: FirebaseAnalyticsProtocol.Type

  init(firebaseAnalytics: FirebaseAnalyticsProtocol.Type) {
    self.firebaseAnalytics = firebaseAnalytics
  }

  func log(type: PBAnalyticsType) {
    firebaseAnalytics.logEvent(type.name, parameters: type.parameters)
  }
}
