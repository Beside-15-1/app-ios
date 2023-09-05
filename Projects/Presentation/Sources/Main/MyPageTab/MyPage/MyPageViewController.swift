//
//  MyPageViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/20.
//

import UIKit

import ReactorKit
import RxSwift

import DesignSystem
import PBLog
import PresentationInterface

final class MyPageViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = MyPageView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  private var transition: UIViewControllerAnimatedTransitioning?

  private let loginBuilder: LoginBuildable
  private let manageTagBuilder: ManageTagBuildable
  private let webBuilder: PBWebBuildable
  private let deleteAccountBuilder: DeleteAccountBuildable

  // MARK: Initializing

  init(
    reactor: MyPageViewReactor,
    loginBuilder: LoginBuildable,
    manageTagBuilder: ManageTagBuildable,
    webBuilder: PBWebBuildable,
    deleteAccountBuilder: DeleteAccountBuildable
  ) {
    defer { self.reactor = reactor }

    self.loginBuilder = loginBuilder
    self.manageTagBuilder = manageTagBuilder
    self.webBuilder = webBuilder
    self.deleteAccountBuilder = deleteAccountBuilder

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func loadView() {
    view = contentView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    tabBarController?.navigationController?.delegate = self
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.isNavigationBarHidden = true
  }


  // MARK: Binding

  func bind(reactor: MyPageViewReactor) {
    bindButton(with: reactor)
    bindRoute(with: reactor)
  }

  private func bindButton(with reactor: MyPageViewReactor) {
    contentView.logoutButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        PBDialog(
          title: "로그아웃",
          content: "정말 로그아웃 하시겠어요?",
          from: self
        )
        .addAction(content: "아니오", priority: .secondary, action: nil)
        .addAction(content: "로그아웃", priority: .primary, action: {
          self.reactor?.action.onNext(.logoutButtonTapped)
        })
        .show()
      }
      .disposed(by: disposeBag)

    contentView.themeButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
          return
        }
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
      }
      .disposed(by: disposeBag)

    contentView.navigationBar.masterDetailButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.splitViewController?.changeDisplayMode(to: .oneBesideSecondary)
        self.contentView.navigationBar.masterDetailButton.isHidden = true
      }
      .disposed(by: disposeBag)
  }

  private func bindRoute(with reactor: MyPageViewReactor) {
    reactor.state.map(\.isLogoutSuccess)
      .asObservable()
      .distinctUntilChanged()
      .filter { $0 }
      .subscribe(with: self) { `self`, _ in
        let vc = self.loginBuilder.build(payload: .init())
        self.splitViewController?.changeDisplayMode(to: .secondaryOnly)
        self.transition = FadeAnimator(animationDuration: 0.5, isPresenting: true)
        let navigation = self.splitViewController?.viewController(for: .secondary) as? UINavigationController
        navigation?.setViewControllers([vc], animated: true)
        self.transition = nil
      }
      .disposed(by: disposeBag)

    reactor.pulse(\.$isLogoutFailure)
      .filter { $0 }
      .asObservable()
      .subscribe(with: self) { `self`, _ in
        PBToast(content: "로그아웃에 실패했어요 다시 시도해주세요")
          .show()
      }
      .disposed(by: disposeBag)

    contentView.tagButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        let manageTag = self.manageTagBuilder.build(payload: .init())

        self.navigationController?.pushViewController(manageTag, animated: true)
      }
      .disposed(by: disposeBag)

    contentView.serviceButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        guard let url = URL(string: "https://joosum.notion.site/6df241a6e3174b8fbfc7933a506a0b1e?pvs=4") else {
          return
        }

        let web = self.webBuilder.build(payload: .init(url: url))

        self.presentFormSheet(web)
      }
      .disposed(by: disposeBag)

    contentView.securityButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        guard let url = URL(string: "https://joosum.notion.site/a078243be717462296cbe664a121212c?pvs=4") else {
          return
        }

        let web = self.webBuilder.build(payload: .init(url: url))

        self.presentFormSheet(web)
      }
      .disposed(by: disposeBag)

    contentView.csButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        guard let url = URL(string: "https://forms.gle/NcvHeu6FGyKuwm1Z8") else {
          return
        }

        let options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:]

        UIApplication.shared.open(url, options: options)
      }
      .disposed(by: disposeBag)

    contentView.deleteAccountButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        let deleteAccount = self.deleteAccountBuilder.build(
          payload: .init(
            delegate: self
          )
        )

        self.navigationController?.pushViewController(deleteAccount, animated: true)
      }
      .disposed(by: disposeBag)

    contentView.versionButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        // 앱 미설치시 앱스토어로 연결
        if self.contentView.versionButton.canUpdate {
          if let openStore = URL(string: "https://apps.apple.com/kr/app/%EC%A3%BC%EC%84%AC-joosum/id6455258212"),
             UIApplication.shared.canOpenURL(openStore) {
            UIApplication.shared.open(openStore, options: [:], completionHandler: nil)
          }
        }
      }
      .disposed(by: disposeBag)
  }


  // MARK: Configuring

  func configureMasterDetail(displayMode: UISplitViewController.DisplayMode) {
    guard displayMode == .secondaryOnly else { return }
    contentView.navigationBar.masterDetailButton.isHidden = false
  }
}


// MARK: UINavigationControllerDelegate

extension MyPageViewController: UINavigationControllerDelegate {
  func navigationController(
    _ navigationController: UINavigationController,
    animationControllerFor operation: UINavigationController.Operation,
    from fromVC: UIViewController,
    to toVC: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    transition
  }
}


extension MyPageViewController: DeleteAccountDelegate {
  func deleteAccountSuccess() {
    let vc = self.loginBuilder.build(payload: .init())
    self.transition = FadeAnimator(animationDuration: 0.5, isPresenting: true)
    self.splitViewController?.changeDisplayMode(to: .secondaryOnly)
    let navigation = self.splitViewController?.viewController(for: .secondary) as? UINavigationController
    navigation?.setViewControllers([vc], animated: true)
    self.transition = nil
  }
}
