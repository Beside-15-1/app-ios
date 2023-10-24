//
//  OnboardingFolderEvent.swift
//  Presentation
//
//  Created by 박천송 on 2023/10/16.
//

import Foundation

import PBAnalyticsInterface

enum OnboardingFolderEvent {
  case click(component: OnboardingFolderClickComponent)
  case shown
}

extension OnboardingFolderEvent: PBAnalyticsType {
  var name: String {
    switch self {

    case .click:
      return PBAnalyticsEventNameBuilder()
        .action(with: .clicked)
        .screen(with: "onboardingFolder")
        .version(with: 1)
        .build()

    case .shown:
      return PBAnalyticsEventNameBuilder()
        .action(with: .shown)
        .screen(with: "onboardingFolder")
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

enum OnboardingFolderClickComponent: String {
  case next
}
