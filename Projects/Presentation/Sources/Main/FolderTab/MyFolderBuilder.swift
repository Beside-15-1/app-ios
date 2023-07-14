//
//  MyFolderBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/11.
//

import UIKit
import Foundation

import Domain
import PresentationInterface

struct MyFolderDependency {
  let folderRepository: FolderRepository
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
      )
    )

    let viewController = MyFolderViewController(
      reactor: reactor
    )

    return viewController
  }
}
