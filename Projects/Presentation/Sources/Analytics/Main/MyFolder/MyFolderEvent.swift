//
//  MyFolderEvent.swift
//  Presentation
//
//  Created by 박천송 on 2023/10/16.
//

import Foundation

import PBAnalyticsInterface

enum MyFolderEvent {
  case click(component: MyFolderClickComponent)
  case shown
}

// MARK: PBAnalyticsType

extension MyFolderEvent: PBAnalyticsType {
  var name: String {
    switch self {
    case .click:
      return PBAnalyticsEventNameBuilder()
        .action(with: .clicked)
        .screen(with: "myFolder")
        .version(with: 1)
        .build()

    case .shown:
      return PBAnalyticsEventNameBuilder()
        .action(with: .shown)
        .screen(with: "myFolder")
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

enum MyFolderClickComponent: String {
  case addFolder
  case addLink
  case folderSetting
  case sortBy
  case editFolder
  case deleteFolder
  case close
  case createdDate
  case name
  case updatedDate
}

