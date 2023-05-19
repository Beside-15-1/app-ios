//
//  FolderBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/05/19.
//

import Foundation
import UIKit

import Domain
import PresentationInterface

// MARK: - FolderDependency

struct FolderDependency {}

// MARK: - FolderBuilder

final class FolderBuilder: FolderBuildable {
  private let dependency: FolderDependency

  init(dependency: FolderDependency) {
    self.dependency = dependency
  }

  func build(payload: FolderPayload) -> UIViewController {
    let viewModel = FolderViewModel()

    let viewController = FolderViewController(
      viewModel: viewModel
    )

    return viewController
  }
}
