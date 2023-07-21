//
//  HomeBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/05.
//

import Foundation
import UIKit

import Domain
import PresentationInterface

struct HomeDependency {
  let folderRepository: FolderRepository
  let linkRepository: LinkRepository
  let loginRepository: LoginRepository
  let createLinkBuilder: CreateLinkBuildable
  let createFolderBuilder: CreateFolderBuildable
  let folderDetailBuilder: FolderDetailBuildable
}

final class HomeBuilder: HomeBuildable {

  private let dependency: HomeDependency

  init(dependency: HomeDependency) {
    self.dependency = dependency
  }

  func build(payload: HomePayload) -> UIViewController {
    let reactor = HomeViewReactor(
      fetchLinkListUseCase: FetchAllLinksUseCaseImpl(
        linkRepository: dependency.linkRepository
      ),
      fetchFolderListUseCase: FetchFolderListUseCaseImpl(
        folderRepository: dependency.folderRepository
      ),
      getMeUseCase: GetMeUsecaseImpl(
        loginRepository: dependency.loginRepository
      )
    )

    let viewController = HomeViewController(
      reactor: reactor,
      createLinkBuilder: dependency.createLinkBuilder,
      createFolderBuilder: dependency.createFolderBuilder,
      folderDetailBuilder: dependency.folderDetailBuilder
    )

    return viewController
  }
}
