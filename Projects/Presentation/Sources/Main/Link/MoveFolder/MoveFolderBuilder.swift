//
//  MoveFolderBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/19.
//

import UIKit
import Foundation

import Domain
import PresentationInterface
import PBAnalyticsInterface

struct MoveFolderDependency {
  let analytics: PBAnalytics
  let folderRepository: FolderRepository
}

final class MoveFolderBuilder: MoveFolderBuildable {

  private let dependency: MoveFolderDependency

  init(dependency: MoveFolderDependency) {
    self.dependency = dependency
  }

  func build(payload: MoveFolderPayload) -> UIViewController {
    let reactor = MoveFolderViewReactor(
      fetchFolderListUseCase: FetchFolderListUseCaseImpl(
        folderRepository: dependency.folderRepository
      ),
      folderId: payload.folderID
    )

    let viewController = MoveFolderViewController(
      reactor: reactor,
      analytics: dependency.analytics
    ).then {
      $0.delegate = payload.delegate
    }

    return viewController
  }
}
