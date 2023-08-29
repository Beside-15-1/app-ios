//
//  SplitViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/08/24.
//

import UIKit

import ReactorKit
import RxSwift

import PresentationInterface

final class SplitViewController: UISplitViewController {


  // MARK: Properties

  var disposeBag = DisposeBag()

  private var masterViewController: UIViewController?
  private var detailViewController: UIViewController?


  // MARK: Initializing

  init(
    style: UISplitViewController.Style,
    masterBuilder: MasterBuildable,
    mainTabBuilder: MainTabBarBuildable,
    loginBuilder: LoginBuildable,
    isLogin: Bool
  ) {
    super.init(style: style)

    self.masterViewController = masterBuilder.build(payload: .init())

    if isLogin {
      self.detailViewController = mainTabBuilder.build(payload: .init())
    } else {
      self.detailViewController = loginBuilder.build(payload: .init())
    }

    setViewController(UINavigationController(rootViewController: masterViewController!), for: .primary)
    setViewController(UINavigationController(rootViewController: detailViewController!), for: .secondary)
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
    guard displayMode == .secondaryOnly else { return }

    guard let mainTab = detailViewController as? MainTabBarViewController else { return }

    let selectedVC = mainTab.selectedViewController

    if let home = selectedVC as? HomeViewController {
      home.configureMasterDetail()
    } else if let _ = selectedVC as? MyFolderViewController {
    } else if let _ = selectedVC as? MyPageViewController {}
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
