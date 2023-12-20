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
import PBAnalyticsInterface
import PBLog
import PresentationInterface

final class MyPageViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = MyPageView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  private var transition: UIViewControllerAnimatedTransitioning?

  private let analytics: PBAnalytics
  private let loginBuilder: LoginBuildable
  private let manageTagBuilder: ManageTagBuildable
  private let webBuilder: PBWebBuildable
  private let deleteAccountBuilder: DeleteAccountBuildable
  private let NotificationSettingBuilder: NotificationSettingBuildable

  // MARK: Initializing

  init(
    reactor: MyPageViewReactor,
    analytics: PBAnalytics,
    loginBuilder: LoginBuildable,
    manageTagBuilder: ManageTagBuildable,
    webBuilder: PBWebBuildable,
    deleteAccountBuilder: DeleteAccountBuildable,
    NotificationSettingBuilder: NotificationSettingBuildable
  ) {
    defer { self.reactor = reactor }

    self.analytics = analytics
    self.loginBuilder = loginBuilder
    self.manageTagBuilder = manageTagBuilder
    self.webBuilder = webBuilder
    self.deleteAccountBuilder = deleteAccountBuilder
    self.NotificationSettingBuilder = NotificationSettingBuilder

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

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    analytics.log(type: MyPageEvent.shown)
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
          self.analytics.log(type: MyPageEvent.click(component: .logout))
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

        self.analytics.log(type: MyPageEvent.click(component: .settingTag))

        let manageTag = self.manageTagBuilder.build(payload: .init())

        self.navigationController?.pushViewController(manageTag, animated: true)
      }
      .disposed(by: disposeBag)

    contentView.serviceButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        guard let url = URL(string: "https://joosum.notion.site/6df241a6e3174b8fbfc7933a506a0b1e?pvs=4") else {
          return
        }

        self.analytics.log(type: MyPageEvent.click(component: .termsOfService))

        let web = self.webBuilder.build(payload: .init(url: url))

        self.presentPaperSheet(web)
      }
      .disposed(by: disposeBag)

    contentView.securityButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        guard let url = URL(string: "https://joosum.notion.site/a078243be717462296cbe664a121212c?pvs=4") else {
          return
        }

        self.analytics.log(type: MyPageEvent.click(component: .privacyPolicy))

        let web = self.webBuilder.build(payload: .init(url: url))

        self.presentPaperSheet(web)
      }
      .disposed(by: disposeBag)

    contentView.csButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        guard let url = URL(string: "https://forms.gle/NcvHeu6FGyKuwm1Z8") else {
          return
        }

        self.analytics.log(type: MyPageEvent.click(component: .contact))

        let options: [UIApplication.OpenExternalURLOptionsKey: Any] = [:]

        UIApplication.shared.open(url, options: options)
      }
      .disposed(by: disposeBag)

    contentView.deleteAccountButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.analytics.log(type: MyPageEvent.click(component: .deleteAccount))

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
          self.analytics.log(type: MyPageEvent.click(component: .version))
          if let openStore = URL(string: "https://apps.apple.com/kr/app/%EC%A3%BC%EC%84%AC-joosum/id6455258212"),
             UIApplication.shared.canOpenURL(openStore) {
            UIApplication.shared.open(openStore, options: [:], completionHandler: nil)
          }
        }
      }
      .disposed(by: disposeBag)

    contentView.pushButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        let push = self.NotificationSettingBuilder.build(payload: .init())

        self.navigationController?.pushViewController(push, animated: true)
      }
      .disposed(by: disposeBag)

    contentView.noticeButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        guard let url = URL(string: "https://joosum.notion.site/d1bf0517402744ee804c7d645a472610?pvs=4") else {
          return
        }

        self.analytics.log(type: MyPageEvent.click(component: .notice))

        let web = self.webBuilder.build(payload: .init(url: url))

        self.presentPaperSheet(web)
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
    let vc = loginBuilder.build(payload: .init())
    transition = FadeAnimator(animationDuration: 0.5, isPresenting: true)
    splitViewController?.changeDisplayMode(to: .secondaryOnly)
    let navigation = splitViewController?.viewController(for: .secondary) as? UINavigationController
    navigation?.setViewControllers([vc], animated: true)
    transition = nil
  }
}
