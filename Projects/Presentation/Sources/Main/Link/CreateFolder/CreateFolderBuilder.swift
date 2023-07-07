import Foundation
import UIKit

import Domain
import PresentationInterface

// MARK: - CreateFolderDependency

struct CreateFolderDependency {
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
      folder: payload.folder
    )

    let viewController = CreateFolderViewController(
      reactor: reactor
    )

    return viewController
  }
}
