//
//  MasterBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/08/28.
//

import Foundation
import UIKit

import Domain
import PresentationInterface

struct MasterDependency {
  let folderRepository: FolderRepository
}

final class MasterBuilder: MasterBuildable {

  private let dependency: MasterDependency

  init(dependency: MasterDependency) {
    self.dependency = dependency
  }

  func build(payload: MasterPayload) -> UIViewController {
    let reactor = MasterViewReactor(
      fetchFolderListUseCase: FetchFolderListUseCaseImpl(folderRepository: dependency.folderRepository),
      getFodlerListUseCase: GetFolderListUseCaseImpl(folderRepository: dependency.folderRepository)
    )

    let viewController = MasterViewController(
      reactor: reactor
    ).then {
      $0.delegate = payload.delegate
    }

    return viewController
  }
}
