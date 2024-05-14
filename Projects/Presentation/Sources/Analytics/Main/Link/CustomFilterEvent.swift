//
//  CustomFilterEvent.swift
//  Presentation
//
//  Created by 박천송 on 5/14/24.
//

import Foundation

import PBAnalyticsInterface

enum CustomFilterEvent {
  case click(component: CustomFilterClickComponent)
  case shown
}

// MARK: PBAnalyticsType

extension CustomFilterEvent: PBAnalyticsType {
  var name: String {
    switch self {
    case .click:
      return PBAnalyticsEventNameBuilder()
        .action(with: .clicked)
        .screen(with: "filter")
        .version(with: 1)
        .build()

    case .shown:
      return PBAnalyticsEventNameBuilder()
        .action(with: .shown)
        .screen(with: "filter")
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

enum CustomFilterClickComponent: String {
  case toggle
  case dateYear
  case dateMonth
  case dateCustom
  case addTag
  case deleteTag
  case reset
  case applyFilter
  case close
}


