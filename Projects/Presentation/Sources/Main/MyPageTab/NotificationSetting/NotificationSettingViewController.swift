//
//  NotificationSettingViewController.swift
//  Presentation
//
//  Created by 박천송 on 10/24/23.
//

import UIKit

import ReactorKit
import RxSwift

import DesignSystem

final class NotificationSettingViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = NotificationSettingView()


  // MARK: Properties

  var disposeBag = DisposeBag()


  // MARK: Initializing

  init(reactor: NotificationSettingViewReactor) {
    defer { self.reactor = reactor }
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

    reactor?.action.onNext(.viewDidLoad)

    navigationController?.interactivePopGestureRecognizer?.delegate = nil
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    reactor?.action.onNext(.viewDidAppear)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    navigationController?.isNavigationBarHidden = false

    configureNavigationBar()
  }


  // MARK: Binding

  func bind(reactor: NotificationSettingViewReactor) {
    reactor.state.map(\.config)
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, config in
        self.contentView.unreadItem.configureSwitch(isOn: config.isReadAgree)
        self.contentView.unclassifyItem.configureSwitch(isOn: config.isClassifyAgree)
      }
      .disposed(by: disposeBag)

    contentView.unreadItem.settingSwitch.rx.isOn
      .skip(1)
      .map { Reactor.Action.updateUnreadAgree($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    contentView.unclassifyItem.settingSwitch.rx.isOn
      .skip(1)
      .map { Reactor.Action.updateUnclassifyAgree($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
}


// MARK: - NavigationBar

extension NotificationSettingViewController {

  private func configureNavigationBar() {
    let backButton = UIBarButtonItem(
      image: DesignSystemAsset.iconChevronLeftLarge.image.withTintColor(.staticBlack),
      style: .plain,
      target: self,
      action: #selector(pop)
    )

    navigationItem.leftBarButtonItem = backButton
    navigationItem.leftBarButtonItem?.tintColor = .staticBlack
    navigationItem.title = "알림 설정"

    let attributes = [
      NSAttributedString.Key.foregroundColor: UIColor.staticBlack,
      NSAttributedString.Key.font: UIFont.titleBold,
    ]
    navigationController?.navigationBar.titleTextAttributes = attributes
  }

  @objc
  private func pop() {
    navigationController?.popViewController(animated: true)
  }
}
