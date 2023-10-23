//
//  FolderDetailBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/17.
//

import Foundation
import UIKit

import Domain
import PBAnalyticsInterface
import PresentationInterface

struct FolderDetailDependency {
  let analytics: PBAnalytics
  let linkRepository: LinkRepository
  let folderRepository: FolderRepository
  let linkSortBuilder: LinkSortBuildable
  let linkDetailBuilder: LinkDetailBuildable
  let createLinkBuilder: CreateLinkBuildable
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
      readLinkUseCase: ReadLinkUseCaseImpl(linkRepository: dependency.linkRepository),
      folderList: payload.folderList,
      selectedFolder: payload.selectedFolder
    )

    let viewController = FolderDetailViewController(
      reactor: reactor,
      analytics: dependency.analytics,
      linkSortBuilder: dependency.linkSortBuilder,
      linkDetailBuilder: dependency.linkDetailBuilder,
      createLinkBuilder: dependency.createLinkBuilder
    )

    return viewController
  }
}
