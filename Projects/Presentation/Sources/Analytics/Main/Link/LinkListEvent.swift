//
//  LinkListEvent.swift
//  Presentation
//
//  Created by 박천송 on 2023/10/17.
//

import Foundation

import PBAnalyticsInterface

enum LinkListEvent {
  case click(component: LinkListClickComponent)
  case shown
}

// MARK: PBAnalyticsType

extension LinkListEvent: PBAnalyticsType {
  var name: String {
    switch self {
    case .click:
      return PBAnalyticsEventNameBuilder()
        .action(with: .clicked)
        .screen(with: "linkList")
        .version(with: 1)
        .build()

    case .shown:
      return PBAnalyticsEventNameBuilder()
        .action(with: .shown)
        .screen(with: "linkList")
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

enum LinkListClickComponent: String {
  case back
  case tabOtherFolder
  case searchInput
  case search
  case filterUnread
  case sortby
  case link
  case buttonKebab
  case editOn
  case editOff
  case checkLink
  case checkAll
  case deleteLink
}


