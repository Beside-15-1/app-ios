//
//  EditLinkEvent.swift
//  Presentation
//
//  Created by 박천송 on 2023/10/17.
//

import Foundation

import PBAnalyticsInterface

enum EditLinkEvent {
  case click(component: EditLinkClickComponent)
  case shown
}

// MARK: PBAnalyticsType

extension EditLinkEvent: PBAnalyticsType {
  var name: String {
    switch self {
    case .click:
      return PBAnalyticsEventNameBuilder()
        .action(with: .clicked)
        .screen(with: "editLink")
        .version(with: 1)
        .build()

    case .shown:
      return PBAnalyticsEventNameBuilder()
        .action(with: .shown)
        .screen(with: "editLink")
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

enum EditLinkClickComponent: String {
  case urlInput
  case titleInput
  case addFolder
  case addTag
  case selectFolder
  case deleteTag
  case saveLink
  case close
}
