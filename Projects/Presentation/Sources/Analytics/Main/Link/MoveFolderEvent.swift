//
//  MoveFolderEvent.swift
//  Presentation
//
//  Created by 박천송 on 2023/10/17.
//

import Foundation

import PBAnalyticsInterface

enum MoveFolderEvent {
  case click(component: MoveFolderClickComponent)
  case shown
}

// MARK: PBAnalyticsType

extension MoveFolderEvent: PBAnalyticsType {
  var name: String {
    switch self {
    case .click:
      return PBAnalyticsEventNameBuilder()
        .action(with: .clicked)
        .screen(with: "moveFolder")
        .version(with: 1)
        .build()

    case .shown:
      return PBAnalyticsEventNameBuilder()
        .action(with: .shown)
        .screen(with: "moveFolder")
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

enum MoveFolderClickComponent: String {
  case folder
  case moveFolder
  case close
}

