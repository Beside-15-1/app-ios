//
//  AddLinkEvent.swift
//  Presentation
//
//  Created by 박천송 on 2023/10/16.
//

import Foundation

import PBAnalyticsInterface

enum AddLinkEvent {
  case click(component: AddLinkClickComponent)
  case shown
}

// MARK: PBAnalyticsType

extension AddLinkEvent: PBAnalyticsType {
  var name: String {
    switch self {
    case .click:
      return PBAnalyticsEventNameBuilder()
        .action(with: .clicked)
        .screen(with: "addLink")
        .version(with: 1)
        .build()

    case .shown:
      return PBAnalyticsEventNameBuilder()
        .action(with: .shown)
        .screen(with: "addLink")
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

enum AddLinkClickComponent: String {
  case urlDone
  case titleDone
  case addFolder
  case addTag
  case selectFolder
  case deleteTag
  case saveLink
  case close
}
