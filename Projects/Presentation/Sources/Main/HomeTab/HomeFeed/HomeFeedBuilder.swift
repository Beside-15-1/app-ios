//
//  HomeFeedBuilder.swift
//  Presentation
//
//  Created by 박천송 on 6/21/24.
//

import Foundation
import UIKit

import Domain
import PBAnalyticsInterface
import PresentationInterface

struct HomeFeedDependency {
  let analytics: PBAnalytics
  let linkRepository: LinkRepository
  let folderRepository: FolderRepository
  let folderDetailBuilder: FolderDetailBuildable
  let webBuilder: PBWebBuildable
  let createLinkBuilder: CreateLinkBuildable
}

final class HomeFeedBuilder: HomeFeedBuildable {

  private let dependency: HomeFeedDependency

  init(dependency: HomeFeedDependency) {
    self.dependency = dependency
  }

  func build(payload: HomeFeedPayload) -> UIViewController {
    let reactor = HomeFeedViewReactor(
      analytics: dependency.analytics,
      fetchLinkListUseCase: FetchAllLinksUseCaseImpl(
        linkRepository: dependency.linkRepository
      ),
      readLinkUseCase: ReadLinkUseCaseImpl(
        linkRepository: dependency.linkRepository
      ),
      fetchFolderListUseCase: FetchFolderListUseCaseImpl(
        folderRepository: dependency.folderRepository
      )
    )

    let viewController = HomeFeedViewController(
      reactor: reactor,
      analytics: dependency.analytics,
      folderDetailBuilder: dependency.folderDetailBuilder,
      webBuilder: dependency.webBuilder,
      createLinkBuilder: dependency.createLinkBuilder
    )

    return viewController
  }
}
