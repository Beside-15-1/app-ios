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

struct EditFolderDependency {}

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
      reactor: reactor
    )

    return viewController
  }
}
