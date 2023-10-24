//
//  EditFolderEvent.swift
//  Presentation
//
//  Created by 박천송 on 2023/10/16.
//

import Foundation

import PBAnalyticsInterface

enum EditFolderEvent {
  case click(component: EditFolderClickComponent)
  case shown
}

// MARK: PBAnalyticsType

extension EditFolderEvent: PBAnalyticsType {
  var name: String {
    switch self {
    case .click:
      return PBAnalyticsEventNameBuilder()
        .action(with: .clicked)
        .screen(with: "editFolder")
        .version(with: 1)
        .build()

    case .shown:
      return PBAnalyticsEventNameBuilder()
        .action(with: .shown)
        .screen(with: "editFolder")
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

enum EditFolderClickComponent: String {
  case folderTitleTab
  case folderColorTab
  case folderIllustTab
  case folderTitleInput
  case folderColorButton
  case folderIllustButton
  case saveFolder
  case close
}

