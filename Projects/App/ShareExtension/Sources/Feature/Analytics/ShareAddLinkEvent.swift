//
//  ShareAddLinkEvent.swift
//  ShareExtension
//
//  Created by 박천송 on 2023/10/17.
//

import Foundation

import PBAnalyticsInterface

enum ShareAddLinkEvent {
  case click(component: ShareAddLinkClickComponent)
  case shown
}

// MARK: PBAnalyticsType

extension ShareAddLinkEvent: PBAnalyticsType {
  var name: String {
    switch self {
    case .click:
      return PBAnalyticsEventNameBuilder()
        .action(with: .clicked)
        .screen(with: "shareAddLink")
        .version(with: 1)
        .build()

    case .shown:
      return PBAnalyticsEventNameBuilder()
        .action(with: .shown)
        .screen(with: "shareAddLink")
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

enum ShareAddLinkClickComponent: String {
  case titleInput
  case selectFolder
  case addFolder
  case addTag
  case done
  case close
}


