import Foundation
import UIKit

import Domain
import PresentationInterface

// MARK: - CreateLinkDependency

struct CreateLinkDependency {
  let folderRepository: FolderRepository
  let selectFolderBuilder: SelectFolderBuildable
  let tagAddBuilder: TagAddBuildable
  let createFolderBuilder: CreateFolderBuildable
}

// MARK: - CreateLinkBuilder

final class CreateLinkBuilder: CreateLinkBuildable {
  private let dependency: CreateLinkDependency

  init(dependency: CreateLinkDependency) {
    self.dependency = dependency
  }

  func build(payload: CreateLinkPayload) -> UIViewController {
    let reactor = CreateLinkViewReactor(
      fetchThumbnailUseCase: FetchThumbnailUseCaseImpl(metadataProvider: .init()),
      fetchFolderListUseCase: FetchFolderListUseCaseImpl(
        folderRepository: dependency.folderRepository
      )
    )

    let viewController = CreateLinkViewController(
      reactor: reactor,
      selectFolderBuilder: dependency.selectFolderBuilder,
      tagAddBuilder: dependency.tagAddBuilder,
      createFolderBuilder: dependency.createFolderBuilder
    )

    return viewController
  }
}
