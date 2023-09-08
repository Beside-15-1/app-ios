//
//  SplitBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/08/24.
//

import Foundation
import UIKit

import Domain
import PresentationInterface

struct SplitDependency {
  let masterBuilder: MasterBuildable
  let mainTabBuilder: MainTabBarBuildable
  let loginBuilder: LoginBuildable
  let folderDetailBuilder: FolderDetailBuildable
  let createFolderBuilder: CreateFolderBuildable
  let folderRepository: FolderRepository
}

final class SplitBuilder: SplitBuildable {

  private let dependency: SplitDependency

  init(dependency: SplitDependency) {
    self.dependency = dependency
  }

  func build(payload: SplitPayload) -> UIViewController {

    let split = SplitViewController(
      style: .doubleColumn,
      masterBuilder: dependency.masterBuilder,
      mainTabBuilder: dependency.mainTabBuilder,
      loginBuilder: dependency.loginBuilder,
      folderDetailBuilder: dependency.folderDetailBuilder,
      createFolderBuilder: dependency.createFolderBuilder,
      folderRepository: dependency.folderRepository,
      isLogin: payload.isLogin
    )

    return split
  }
}
