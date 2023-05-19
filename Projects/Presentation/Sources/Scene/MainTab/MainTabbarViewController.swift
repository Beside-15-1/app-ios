//
//  MainTabBarViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/05/19.
//

import UIKit

import RxSwift

import PresentationInterface

final class MainTabBarViewController: UITabBarController {
  private let homeBuilder: HomeBuildable
  private let folderBuilder: FolderBuildable
  private let myPageBuilder: MyPageBuildable

  // MARK: Initializing

  init(
    homeBuilder: HomeBuildable,
    folderBuilder: FolderBuildable,
    myPageBuilder: MyPageBuildable
  ) {
    self.homeBuilder = homeBuilder
    self.folderBuilder = folderBuilder
    self.myPageBuilder = myPageBuilder

    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
