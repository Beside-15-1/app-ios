//
//  LinkDetailBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/18.
//

import UIKit
import Foundation

import Domain
import PresentationInterface

struct LinkDetailDependency {
  let linkRepository: LinkRepository
  let createLinkBuilder: CreateLinkBuildable
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
      link: payload.link
    )

    let viewController = LinkDetailViewController(
      reactor: reactor,
      createLinkBuilder: dependency.createLinkBuilder
    )

    return viewController
  }
}
