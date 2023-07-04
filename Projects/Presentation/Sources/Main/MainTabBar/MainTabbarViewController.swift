import UIKit

import RxCocoa
import RxSwift
import Then

import PresentationInterface

// MARK: - MainTabBarViewController

final class MainTabBarViewController: UITabBarController {
  // MARK: Properties

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

    setViewControllers()
  }

  private func setViewControllers() {
    let homeVC = homeBuilder.build(payload: .init())
    let folderVC = folderBuilder.build(payload: .init())
    let myPageVC = myPageBuilder.build(payload: .init())

    homeVC.tabBarItem.title = "홈"
    folderVC.tabBarItem.title = "폴더"
    myPageVC.tabBarItem.title = "내정보"

    viewControllers = [homeVC, folderVC, myPageVC]
  }
}
