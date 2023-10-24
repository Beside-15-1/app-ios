//
//  LinkDetailEvent.swift
//  Presentation
//
//  Created by 박천송 on 2023/10/17.
//

import Foundation

import PBAnalyticsInterface

enum LinkDetailEvent {
  case click(component: LinkDetailClickComponent)
  case shown
}

// MARK: PBAnalyticsType

extension LinkDetailEvent: PBAnalyticsType {
  var name: String {
    switch self {
    case .click:
      return PBAnalyticsEventNameBuilder()
        .action(with: .clicked)
        .screen(with: "linkDetail")
        .version(with: 1)
        .build()

    case .shown:
      return PBAnalyticsEventNameBuilder()
        .action(with: .shown)
        .screen(with: "linkDetail")
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

enum LinkDetailClickComponent: String {
  case back
  case share
  case thumbnail
  case delete
  case moveFolder
  case editLink
  case folderName
}

