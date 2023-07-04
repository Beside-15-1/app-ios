import Foundation
import UIKit

import Domain
import PresentationInterface

// MARK: - CreateLinkDependency

struct CreateLinkDependency {
  let selectFolderBuilder: SelectFolderBuildable
  let tagAddBuilder: TagAddBuildable
}

// MARK: - CreateLinkBuilder

final class CreateLinkBuilder: CreateLinkBuildable {
  private let dependency: CreateLinkDependency

  init(dependency: CreateLinkDependency) {
    self.dependency = dependency
  }

  func build(payload: CreateLinkPayload) -> UIViewController {
    let reactor = CreateLinkViewReactor(
      fetchThumbnailUseCase: FetchThumbnailUseCaseImpl(metadataProvider: .init())
    )

    let viewController = CreateLinkViewController(
      reactor: reactor,
      selectFolderBuilder: dependency.selectFolderBuilder,
      tagAddBuilder: dependency.tagAddBuilder
    )

    return viewController
  }
}
