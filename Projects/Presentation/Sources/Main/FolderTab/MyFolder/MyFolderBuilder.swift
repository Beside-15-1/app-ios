//
//  MyFolderBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/11.
//

import Foundation
import UIKit

import Domain
import PresentationInterface
import PBAnalyticsInterface

struct MyFolderDependency {
  let analytics: PBAnalytics
  let folderRepository: FolderRepository
  let createFolderBuilder: CreateFolderBuildable
  let editFolderBuilder: EditFolderBuildable
  let folderSortBuilder: FolderSortBuildable
  let folderDetailBuilder: FolderDetailBuildable
  let createLinkBuilder: CreateLinkBuildable
}

final class MyFolderBuilder: MyFolderBuildable {

  private let dependency: MyFolderDependency

  init(dependency: MyFolderDependency) {
    self.dependency = dependency
  }

  func build(payload: MyFolderPayload) -> UIViewController {
    let reactor = MyFolderViewReactor(
      fetchFolderListUseCase: FetchFolderListUseCaseImpl(
        folderRepository: dependency.folderRepository
      ),
      deleteFolderUseCase: DeleteFolderUseCaseImpl(
        folderRepository: dependency.folderRepository
      ),
      getFolderListUseCase: GetFolderListUseCaseImpl(
        folderRepository: dependency.folderRepository
      )
    )

    let viewController = MyFolderViewController(
      reactor: reactor,
      analytics: dependency.analytics,
      createFolderBuilder: dependency.createFolderBuilder,
      editFolderBuilder: dependency.editFolderBuilder,
      folderSortBuilder: dependency.folderSortBuilder,
      folderDetailBuilder: dependency.folderDetailBuilder,
      createLinkBuilder: dependency.createLinkBuilder
    )

    return viewController
  }
}
