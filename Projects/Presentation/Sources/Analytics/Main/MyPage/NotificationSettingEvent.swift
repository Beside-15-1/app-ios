//
//  NotificationSettingEvent.swift
//  Presentation
//
//  Created by 박천송 on 12/20/23.
//

import Foundation

import PBAnalyticsInterface

enum NotificationSettingEvent {
  case click(component: NotificationSettingClickComponent)
  case shown
}

// MARK: PBAnalyticsType

extension NotificationSettingEvent: PBAnalyticsType {
  var name: String {
    switch self {
    case .click:
      return PBAnalyticsEventNameBuilder()
        .action(with: .clicked)
        .screen(with: "notificationSetting")
        .version(with: 1)
        .build()

    case .shown:
      return PBAnalyticsEventNameBuilder()
        .action(with: .shown)
        .screen(with: "notificationSetting")
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

    case .shown:
      return nil
    }
  }
}

enum NotificationSettingClickComponent: String {
  case back
  case unreadOn
  case unreadOff
  case unclassifiedOn
  case unclassifiedOff
}

