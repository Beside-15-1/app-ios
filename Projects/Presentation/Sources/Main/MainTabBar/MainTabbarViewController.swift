import UIKit

import RxCocoa
import RxSwift
import Then

import DesignSystem
import PresentationInterface

// MARK: - MainTabBarViewController

final class MainTabBarViewController: UITabBarController {
  // MARK: Properties

  private let homeBuilder: HomeBuildable
  private let folderBuilder: MyFolderBuildable
  private let myPageBuilder: MyPageBuildable

  // MARK: Initializing

  init(
    homeBuilder: HomeBuildable,
    folderBuilder: MyFolderBuildable,
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

    for item in tabBar.items ?? [] {
      item.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: -5, right: 0) // 원하는 간격 값으로 설정
      item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 5) // 원하는 간격 값으로 설정
    }
  }

  private func setViewControllers() {
    let homeVC = homeBuilder.build(payload: .init())
    let folderVC = folderBuilder.build(payload: .init())
    let myPageVC = myPageBuilder.build(payload: .init())

    let selecteAttributes = [
      NSAttributedString.Key.font: UIFont.captionSemiBold,
      NSAttributedString.Key.foregroundColor: UIColor.primary500,
    ]

    let deselecteAttributes = [
      NSAttributedString.Key.font: UIFont.captionSemiBold,
      NSAttributedString.Key.foregroundColor: UIColor.gray500,
    ]

    homeVC.tabBarItem = UITabBarItem(
      title: "홈",
      image: DesignSystemAsset.iconHomeOutline.image.withTintColor(.gray500),
      tag: 0
    )
    homeVC.tabBarItem.selectedImage = DesignSystemAsset.iconHomeFill.image.withTintColor(.primary500)
    homeVC.tabBarItem.setTitleTextAttributes(selecteAttributes, for: .selected)
    homeVC.tabBarItem.setTitleTextAttributes(deselecteAttributes, for: .normal)

    folderVC.tabBarItem = UITabBarItem(
      title: "내 폴더",
      image: DesignSystemAsset.iconFolderOutline.image.withTintColor(.gray500),
      tag: 1
    )
    folderVC.tabBarItem.selectedImage = DesignSystemAsset.iconFolderFill.image.withTintColor(.primary500)
    folderVC.tabBarItem.setTitleTextAttributes(selecteAttributes, for: .selected)
    folderVC.tabBarItem.setTitleTextAttributes(deselecteAttributes, for: .normal)

    myPageVC.tabBarItem = UITabBarItem(
      title: "내 정보",
      image: DesignSystemAsset.iconPersonOutline.image.withTintColor(.gray500),
      tag: 2
    )
    myPageVC.tabBarItem.selectedImage = DesignSystemAsset.iconPersonFill.image.withTintColor(.primary500)
    myPageVC.tabBarItem.setTitleTextAttributes(selecteAttributes, for: .selected)
    myPageVC.tabBarItem.setTitleTextAttributes(deselecteAttributes, for: .normal)

    tabBar.tintColor = .primary500
    tabBar.unselectedItemTintColor = .gray500
    tabBar.backgroundColor = .paperCard

    tabBar.layer.cornerRadius = 16
    tabBar.layer.masksToBounds = true

    viewControllers = [homeVC, folderVC, myPageVC]
  }
}
