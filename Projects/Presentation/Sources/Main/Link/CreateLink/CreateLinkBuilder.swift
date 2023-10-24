import Foundation
import UIKit

import Domain
import PBAnalyticsInterface
import PresentationInterface

// MARK: - CreateLinkDependency

struct CreateLinkDependency {
  let analytics: PBAnalytics
  let folderRepository: FolderRepository
  let linkRepository: LinkRepository
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
      analytics: dependency.analytics,
      fetchThumbnailUseCase: FetchThumbnailUseCaseImpl(
        linkRepository: dependency.linkRepository
      ),
      fetchFolderListUseCase: FetchFolderListUseCaseImpl(
        folderRepository: dependency.folderRepository
      ),
      createLinkUseCase: CreateLinkUseCaseImpl(
        linkRepository: dependency.linkRepository
      ),

      updateLinkUseCase: UpdateLinkUseCaseImpl(
        linkRepository: dependency.linkRepository
      ),
      pasteboard: UIPasteboard.general,
      link: payload.link
    )

    let viewController = CreateLinkViewController(
      reactor: reactor,
      analytics: dependency.analytics,
      selectFolderBuilder: dependency.selectFolderBuilder,
      tagAddBuilder: dependency.tagAddBuilder,
      createFolderBuilder: dependency.createFolderBuilder
    ).then {
      $0.delegate = payload.delegate
    }

    return viewController
  }
}
