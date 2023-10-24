//
//  DeleteAccountEvent.swift
//  Presentation
//
//  Created by 박천송 on 2023/10/17.
//

import Foundation

import PBAnalyticsInterface

enum DeleteAccountEvent {
  case click(component: DeleteAccountClickComponent)
  case shown
}

// MARK: PBAnalyticsType

extension DeleteAccountEvent: PBAnalyticsType {
  var name: String {
    switch self {
    case .click:
      return PBAnalyticsEventNameBuilder()
        .action(with: .clicked)
        .screen(with: "deleteAccount")
        .version(with: 1)
        .build()

    case .shown:
      return PBAnalyticsEventNameBuilder()
        .action(with: .shown)
        .screen(with: "deleteAccount")
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

enum DeleteAccountClickComponent: String {
  case back
  case checkAgreeToDeleteData
  case deleteAccount
  case continueUsing
  case confirmdelete
  case canceldelete
}


