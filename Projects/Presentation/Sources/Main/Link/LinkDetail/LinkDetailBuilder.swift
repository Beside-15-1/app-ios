//
//  LinkDetailBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/18.
//

import Foundation
import UIKit

import Domain
import PresentationInterface

struct LinkDetailDependency {
  let linkRepository: LinkRepository
  let createLinkBuilder: CreateLinkBuildable
  let moveFolderBuilder: MoveFolderBuildable
  let webBuilder: PBWebBuildable
}

final class LinkDetailBuilder: LinkDetailBuildable {

  private let dependency: LinkDetailDependency

  init(dependency: LinkDetailDependency) {
    self.dependency = dependency
  }

  func build(payload: LinkDetailPayload) -> UIViewController {
    let reactor = LinkDetailViewReactor(
      deleteLinkUseCase: DeleteLinkUseCaseImpl(
        linkRepository: dependency.linkRepository
      ),
      updateLinkWithFolderUseCase: UpdateLinkWithFolderUseCaseImpl(
        linkRepository: dependency.linkRepository
      ),
      readLinkUseCase: ReadLinkUseCaseImpl(linkRepository: dependency.linkRepository),
      link: payload.link
    )

    let viewController = LinkDetailViewController(
      reactor: reactor,
      createLinkBuilder: dependency.createLinkBuilder,
      moveFolderBuilder: dependency.moveFolderBuilder,
      webBuilder: dependency.webBuilder
    ).then {
      $0.delegate = payload.delegate
    }

    return viewController
  }
}
