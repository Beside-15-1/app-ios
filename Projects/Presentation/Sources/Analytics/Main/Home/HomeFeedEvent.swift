//
//  HomeEvent.swift
//  Presentation
//
//  Created by 박천송 on 2023/10/16.
//

import Foundation

import PBAnalyticsInterface

enum HomeFeedEvent {
  case click(component: HomeFeedClickComponent)
  case shown
}

// MARK: PBAnalyticsType

extension HomeFeedEvent: PBAnalyticsType {
  var name: String {
    switch self {
    case .click:
      return PBAnalyticsEventNameBuilder()
        .action(with: .clicked)
        .screen(with: "home")
        .version(with: 1)
        .build()

    case .shown:
      return PBAnalyticsEventNameBuilder()
        .action(with: .shown)
        .screen(with: "home")
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

enum HomeFeedClickComponent: String {
  case cardAddLink
  case floatingAddLink
  case myFolder
  case addFolder
  case folder
  case saveLink
  case close
  case listUnreadLink
  case listSavedLink
  case moreUnreadLink
  case moreSavedLink
  case bannerSaved
  case bannerUnread

  case tabSaved
  case tabUnread
}
