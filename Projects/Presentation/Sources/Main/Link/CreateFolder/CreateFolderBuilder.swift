import Foundation
import UIKit

import Domain
import PBAnalyticsInterface
import PresentationInterface

// MARK: - CreateFolderDependency

struct CreateFolderDependency {
  let analytics: PBAnalytics
  let folderRepository: FolderRepository
}

// MARK: - CreateFolderBuilder

final class CreateFolderBuilder: CreateFolderBuildable {
  private let dependency: CreateFolderDependency

  init(dependency: CreateFolderDependency) {
    self.dependency = dependency
  }

  func build(payload: CreateFolderPayload) -> UIViewController {
    let reactor = CreateFolderViewReactor(
      createFolderUseCase: CreateFolderUseCaseImpl(
        folderRepository: dependency.folderRepository
      ),
      updateFolderUseCase: UpdateFolderUseCaseImpl(
        folderRepository: dependency.folderRepository
      ),
      getFolderListUseCase: GetFolderListUseCaseImpl(
        folderRepository: dependency.folderRepository
      ),
      folder: payload.folder
    )

    let viewController = CreateFolderViewController(
      reactor: reactor,
      analytics: dependency.analytics
    ).then {
      $0.delegate = payload.delegate
    }

    return viewController
  }
}
