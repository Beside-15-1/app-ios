//
//  CommonEvent.swift
//  Presentation
//
//  Created by 박천송 on 2023/10/17.
//

import Foundation

import PBAnalyticsInterface

enum CommonEvent {
  case click(component: CommonClickComponent)
}

// MARK: PBAnalyticsType

extension CommonEvent: PBAnalyticsType {
  var name: String {
    switch self {

    case .click:
      return PBAnalyticsEventNameBuilder()
        .action(with: .clicked)
        .screen(with: "common")
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

enum CommonClickComponent: String {
  case naviHome
  case naviMyFolder
  case naviMyPage
}

