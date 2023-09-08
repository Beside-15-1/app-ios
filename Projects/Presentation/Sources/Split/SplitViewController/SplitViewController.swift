//
//  SplitViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/08/24.
//

import UIKit

import ReactorKit
import RxSwift

import DesignSystem
import Domain
import PresentationInterface

final class SplitViewController: UISplitViewController {


  // MARK: Properties

  var disposeBag = DisposeBag()

  private var folderDetailBuilder: FolderDetailBuildable?
  private var createFolderBuilder: CreateFolderBuildable?
  private var folderRepository: FolderRepository?

  // MARK: Initializing

  init(
    style: UISplitViewController.Style,
    masterBuilder: MasterBuildable,
    mainTabBuilder: MainTabBarBuildable,
    loginBuilder: LoginBuildable,
    folderDetailBuilder: FolderDetailBuildable,
    createFolderBuilder: CreateFolderBuildable,
    folderRepository: FolderRepository,
    isLogin: Bool
  ) {
    super.init(style: style)

    let masterViewController = masterBuilder.build(payload: .init(delegate: self))
    let detailViewController: UIViewController
    self.folderDetailBuilder = folderDetailBuilder
    self.createFolderBuilder = createFolderBuilder
    self.folderRepository = folderRepository

    if isLogin {
      detailViewController = mainTabBuilder.build(payload: .init())
    } else {
      detailViewController = loginBuilder.build(payload: .init())
    }

    setViewController(UINavigationController(rootViewController: masterViewController), for: .primary)
    setViewController(UINavigationController(rootViewController: detailViewController), for: .secondary)
    minimumPrimaryColumnWidth = 250
    maximumPrimaryColumnWidth = 250
    primaryBackgroundStyle = .sidebar
    presentsWithGesture = false
    if isLogin, UIDevice.current.userInterfaceIdiom == .pad {
      preferredDisplayMode = .oneBesideSecondary
    } else {
      preferredDisplayMode = .automatic
    }
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    delegate = self
  }

  func getRootViewController(svc: UISplitViewController) -> UIViewController? {
    let navigation = svc.viewController(for: .secondary) as? UINavigationController
    let rootViewController = navigation?.viewControllers.first
    return rootViewController
  }
}


extension SplitViewController: UISplitViewControllerDelegate {
  func splitViewController(
    _ splitViewController: UISplitViewController,
    collapseSecondary secondaryViewController: UIViewController,
    onto primaryViewController: UIViewController
  ) -> Bool {
    true
  }

  func splitViewController(_ svc: UISplitViewController, willChangeTo displayMode: UISplitViewController.DisplayMode) {
    guard let mainTab = getRootViewController(svc: svc) as? MainTabBarViewController else { return }

    let selectedVC = mainTab.selectedViewController

    if let home = selectedVC as? HomeViewController {
      home.configureMasterDetail(displayMode: displayMode)
    } else if let myFolder = selectedVC as? MyFolderViewController {
      myFolder.configureMasterDetail(displayMode: displayMode)
    } else if let mypage = selectedVC as? MyPageViewController {
      mypage.configureMasterDetail(displayMode: displayMode)
    }
  }
}


extension UISplitViewController {

  func changeDisplayMode(to newDisplayMode: UISplitViewController.DisplayMode) {
    UIView.animate(withDuration: 0.3) {
      self.preferredDisplayMode = newDisplayMode
      self.view.layoutIfNeeded()
    }
  }
}


extension SplitViewController: MasterDelegate {
  func masterFolderTapped(id: String) {
    guard let mainTab = getRootViewController(svc: self) as? MainTabBarViewController else { return }
    if let _ = mainTab.selectedViewController as? MyFolderViewController {
    } else {
      mainTab.selectedViewController?.navigationController?.popToRootViewController(animated: false)
      mainTab.selectedIndex = 1
    }

    let folders = folderRepository?.getFolderList() ?? .init(folders: [], totalLinkCount: 0)

    let folderDetail = folderDetailBuilder?.build(
      payload: .init(
        folderList: folders.folders,
        selectedFolder: folders.folders.first(where: { $0.id == id }) ?? .all(count: folders.totalLinkCount)
      )
    ) ?? UIViewController()

    if let folder = mainTab.selectedViewController?.navigationController?.topViewController
      as? FolderDetailViewController {
      folder.selectTab(tab: folders.folders.first(where: { $0.id == id })?.title ?? Folder.all().title)
    } else {
      mainTab.selectedViewController?.navigationController?.pushViewController(folderDetail, animated: true)
    }
  }

  func masterMakeFolderButtonTapped() {
    guard let mainTab = getRootViewController(svc: self) as? MainTabBarViewController else { return }
    let selectedVC = mainTab.selectedViewController
    mainTab.selectedViewController?.navigationController?.popToRootViewController(animated: false)
    mainTab.selectedIndex = 1

    if let folder = selectedVC as? MyFolderViewController {
      folder.createFolder()
    }
  }

  func masterHomeTapped() {
    guard let mainTab = getRootViewController(svc: self) as? MainTabBarViewController else { return }
    mainTab.selectedViewController?.navigationController?.popToRootViewController(animated: false)
    mainTab.selectedIndex = 0
  }

  func masterFolderTapped() {
    guard let mainTab = getRootViewController(svc: self) as? MainTabBarViewController else { return }
    mainTab.selectedViewController?.navigationController?.popToRootViewController(animated: false)
    mainTab.selectedIndex = 1
  }

  func masterMyPageTapped() {
    guard let mainTab = getRootViewController(svc: self) as? MainTabBarViewController else { return }
    mainTab.selectedViewController?.navigationController?.popToRootViewController(animated: false)
    mainTab.selectedIndex = 2
  }
}
