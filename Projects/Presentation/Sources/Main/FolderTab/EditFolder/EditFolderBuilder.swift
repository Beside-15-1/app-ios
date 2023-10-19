//
//  EditFolderBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/14.
//

import Foundation
import UIKit

import Domain
import PBAnalyticsInterface
import PresentationInterface

struct EditFolderDependency {
  let analytics: PBAnalytics
  let createFolderBuilder: CreateFolderBuildable
}

final class EditFolderBuilder: EditFolderBuildable {

  private let dependency: EditFolderDependency

  init(dependency: EditFolderDependency) {
    self.dependency = dependency
  }

  func build(payload: EditFolderPayload) -> UIViewController {
    let reactor = EditFolderViewReactor(
      folder: payload.folder
    )

    let viewController = EditFolderViewController(
      reactor: reactor,
      analytics: dependency.analytics,
      createFolderBuilder: dependency.createFolderBuilder
    ).then {
      $0.delegate = payload.delegate
    }

    return viewController
  }
}
