//
//  SignUpEvent.swift
//  Presentation
//
//  Created by 박천송 on 2023/10/16.
//

import Foundation

import PBAnalyticsInterface

enum SignUpEvent {
  case click(component: SignUpClickComponent)
  case shown
}

extension SignUpEvent: PBAnalyticsType {
  var name: String {
    switch self {

    case .click:
      return PBAnalyticsEventNameBuilder()
        .action(with: .clicked)
        .screen(with: "signAddtional")
        .version(with: 1)
        .build()

    case .shown:
      return PBAnalyticsEventNameBuilder()
        .action(with: .shown)
        .screen(with: "signAddtional")
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

enum SignUpClickComponent: String {
  case back
  case skip
  case male
  case female
  case etc
  case birthyear
  case next
}
