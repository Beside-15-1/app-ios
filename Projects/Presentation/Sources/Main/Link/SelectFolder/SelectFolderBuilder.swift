//
//  SelectFolderBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/04.
//

import UIKit
import Foundation

import Domain
import PresentationInterface

struct SelectFolderDependency {}

final class SelectFolderBuilder: SelectFolderBuildable {

  private let dependency: SelectFolderDependency

  init(dependency: SelectFolderDependency) {
    self.dependency = dependency
  }

  func build(payload: SelectFolderPayload) -> UIViewController {
    let reactor = SelectFolderViewReactor(
      folders: payload.folders,
      selectedFolder: payload.selectedFolder
    )

    let viewController = SelectFolderViewController(
      reactor: reactor
    )

    return viewController
  }
}
