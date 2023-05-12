//
//  LoginEvent.swift
//  Presentation
//
//  Created by 박천송 on 2023/05/11.
//

import Foundation

import JSAnalyticsInterface

// MARK: - LoginEvent

enum LoginEvent {
  case clickGoogleLogin
  case clickAppleLogin
}

// MARK: JSAnalyticsType

extension LoginEvent: JSAnalyticsType {
  var name: String {
    switch self {
    case .clickGoogleLogin:
      return JSAnalyticsEventNameBuilder()
        .screen(with: "login")
        .version(with: 1)
        .build()

    case .clickAppleLogin:
      return JSAnalyticsEventNameBuilder()
        .screen(with: "login")
        .version(with: 1)
        .build()
    }
  }

  var parameters: [String: Any]? {
    switch self {
    case .clickGoogleLogin:
      return JSAnalyticsParameterBuilder()
        .action(with: .click)
        .component(with: "googleButton")
        .build()

    case .clickAppleLogin:
      return JSAnalyticsParameterBuilder()
        .action(with: .click)
        .component(with: "appleButton")
        .build()
    }
  }
}
