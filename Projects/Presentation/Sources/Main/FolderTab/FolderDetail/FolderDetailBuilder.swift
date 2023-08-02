//
//  FolderDetailBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/17.
//

import UIKit
import Foundation

import Domain
import PresentationInterface

struct FolderDetailDependency {
  let linkRepository: LinkRepository
  let folderRepository: FolderRepository
  let linkSortBuilder: LinkSortBuildable
  let linkDetailBuilder: LinkDetailBuildable
}

final class FolderDetailBuilder: FolderDetailBuildable {

  private let dependency: FolderDetailDependency

  init(dependency: FolderDetailDependency) {
    self.dependency = dependency
  }

  func build(payload: FolderDetailPayload) -> UIViewController {
    let reactor = FolderDetailViewReactor(
      fetchAllLinkUseCase: FetchAllLinksUseCaseImpl(linkRepository: dependency.linkRepository),
      fetchLinkInFolderUseCase: FetchLinksInFolderUseCaseImpl(linkRepository: dependency.linkRepository),
      getFolderListUseCase: GetFolderListUseCaseImpl(folderRepository: dependency.folderRepository),
      folderList: payload.folderList,
      selectedFolder: payload.selectedFolder
    )

    let viewController = FolderDetailViewController(
      reactor: reactor,
      linkSortBuilder: dependency.linkSortBuilder,
      linkDetailBuilder: dependency.linkDetailBuilder
    )

    return viewController
  }
}
