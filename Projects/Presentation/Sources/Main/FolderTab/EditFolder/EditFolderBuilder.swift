//
//  EditFolderBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/14.
//

import UIKit
import Foundation

import Domain
import PresentationInterface

struct EditFolderDependency {
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
      createFolderBuilder: dependency.createFolderBuilder
    ).then {
      $0.delegate = payload.delegate
    }

    return viewController
  }
}
