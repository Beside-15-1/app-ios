//
//  ShareAddFolderEvent.swift
//  ShareExtension
//
//  Created by 박천송 on 3/14/24.
//  Copyright © 2024 PinkBoss Inc. All rights reserved.
//

import Foundation

import PBAnalyticsInterface

enum ShareAddFolderEvent {
  case click(component: ShareAddFolderClickComponent)
  case shown
}

// MARK: PBAnalyticsType

extension ShareAddFolderEvent: PBAnalyticsType {
  var name: String {
    switch self {
    case .click:
      return PBAnalyticsEventNameBuilder()
        .action(with: .clicked)
        .screen(with: "shareAddFolder")
        .version(with: 1)
        .build()

    case .shown:
      return PBAnalyticsEventNameBuilder()
        .action(with: .shown)
        .screen(with: "shareAddFolder")
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

enum ShareAddFolderClickComponent: String {
  case folderTitleTab
  case folderColorTab
  case folderIllustTab
  case folderTitleInput
  case folderColorButton
  case folderIllustButton
  case saveFolder
  case close
}


