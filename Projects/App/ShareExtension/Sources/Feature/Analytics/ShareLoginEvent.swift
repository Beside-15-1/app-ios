//
//  ShareLoginEvent.swift
//  ShareExtension
//
//  Created by 박천송 on 2023/10/17.
//

import Foundation

import PBAnalyticsInterface

enum ShareLoginEvent {
  case click(component: ShareLoginClickComponent)
}

// MARK: PBAnalyticsType

extension ShareLoginEvent: PBAnalyticsType {
  var name: String {
    switch self {
    case .click:
      return PBAnalyticsEventNameBuilder()
        .action(with: .clicked)
        .screen(with: "shareLogin")
        .version(with: 1)
        .build()
    }
  }

  var parameters: [String: Any]? {
    switch self {
    case .click(let component):
      return PBAnalyticsParameterBuilder()
        .component(with: component.rawValue)
        .build()
    }
  }
}

enum ShareLoginClickComponent: String {
  case login
  case close
}
