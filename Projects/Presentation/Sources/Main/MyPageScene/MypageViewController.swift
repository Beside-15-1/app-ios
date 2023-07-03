import UIKit

import PanModal
import RxSwift

import DesignSystem
import PresentationInterface

// MARK: - MyPageViewController

final class MyPageViewController: UIViewController {
  // MARK: UI

  private lazy var contentView = MyPageView()

  // MARK: Properties

  private let viewModel: MyPageViewModel
  private let disposeBag = DisposeBag()
  private var transition: UIViewControllerAnimatedTransitioning?

  private let loginBuilder: LoginBuildable
  private let tagAddBuilder: TagAddBuildable

  private var backgroundColorTestFlag = true

  // MARK: Initializing

  init(
    viewModel: MyPageViewModel,
    loginBuilder: LoginBuildable,
    tagAddBuilder: TagAddBuildable
  ) {
    self.viewModel = viewModel
    self.loginBuilder = loginBuilder
    self.tagAddBuilder = tagAddBuilder
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
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

    bind(with: viewModel)
  }

  // MARK: Binding

  func bind(with viewModel: MyPageViewModel) {
    bindButtons(with: viewModel)
    bindRoute(with: viewModel)
  }

  func bindButtons(with viewModel: MyPageViewModel) {
    contentView.logoutButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.viewModel.logoutButtonTapped()
      }
      .disposed(by: disposeBag)

    contentView.fab.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.contentView.fab.expand()
        self.contentView.fab.contract()
      }
      .disposed(by: disposeBag)

    contentView.enableButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        guard let vc = self.tagAddBuilder.build(payload: .init(
          tagAddDelegate: nil,
          addedTagList: []
        )) as? PanModalPresentable.LayoutType else { return }

        vc.modalPresentationStyle = .popover

        self.present(vc, animated: true)
      }
      .disposed(by: disposeBag)

    // TabView의 이벤트를 처리하는방법
    // 1. Realy로 처리
    contentView.tab.selectedTab
      .map { "Relay: \($0)" }
      .bind(to: contentView.tabRelayLabel.rx.text)
      .disposed(by: disposeBag)
    // 2. Delegate로 처리
    contentView.tab.delegate = self
  }

  func bindRoute(with viewModel: MyPageViewModel) {
    viewModel.isLogoutSuccess
      .filter { $0 }
      .subscribe(with: self) { `self`, _ in
        let vc = self.loginBuilder.build(payload: .init())
        self.transition = FadeAnimator(animationDuration: 0.5, isPresenting: true)
        self.tabBarController?.navigationController?.setViewControllers([vc], animated: true)
        self.transition = nil
      }
      .disposed(by: disposeBag)
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

// MARK: TabViewDelegate

extension MyPageViewController: TabViewDelegate {
  func tabView(_ tabView: TabView, didSelectedTab: String) {
    contentView.tabDelegateLabel.text = "Delegate: \(didSelectedTab)"
  }
}
