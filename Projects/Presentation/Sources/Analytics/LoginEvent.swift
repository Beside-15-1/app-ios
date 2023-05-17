//
//  LoginEvent.swift
//  Presentation
//
//  Created by 박천송 on 2023/05/11.
//

import Foundation

import PBAnalyticsInterface

// MARK: - LoginEvent

enum LoginEvent {
  case clickGoogleLogin
  case clickAppleLogin
}

// MARK: PBAnalyticsType

extension LoginEvent: PBAnalyticsType {
  var name: String {
    switch self {
    case .clickGoogleLogin:
      return PBAnalyticsEventNameBuilder()
        .screen(with: "login")
        .version(with: 1)
        .build()

    case .clickAppleLogin:
      return PBAnalyticsEventNameBuilder()
        .screen(with: "login")
        .version(with: 1)
        .build()
    }
  }

  var parameters: [String: Any]? {
    switch self {
    case .clickGoogleLogin:
      return PBAnalyticsParameterBuilder()
        .action(with: .click)
        .component(with: "googleButton")
        .build()

    case .clickAppleLogin:
      return PBAnalyticsParameterBuilder()
        .action(with: .click)
        .component(with: "appleButton")
        .build()
    }
  }
}
