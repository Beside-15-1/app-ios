//
//  MyPageEvent.swift
//  Presentation
//
//  Created by 박천송 on 2023/10/17.
//

import Foundation

import PBAnalyticsInterface

enum MyPageEvent {
  case click(component: MyPageClickComponent)
  case shown
}

// MARK: PBAnalyticsType

extension MyPageEvent: PBAnalyticsType {
  var name: String {
    switch self {
    case .click:
      return PBAnalyticsEventNameBuilder()
        .action(with: .clicked)
        .screen(with: "myPage")
        .version(with: 1)
        .build()

    case .shown:
      return PBAnalyticsEventNameBuilder()
        .action(with: .shown)
        .screen(with: "myPage")
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

enum MyPageClickComponent: String {
  case settingTag
  case termsOfService
  case privacyPolicy
  case contact
  case version
  case logout
  case deleteAccount
  case notice
}

