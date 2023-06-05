import UIKit

import RxSwift

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

  // MARK: Initializing

  init(
    viewModel: MyPageViewModel,
    loginBuilder: LoginBuildable
  ) {
    self.viewModel = viewModel
    self.loginBuilder = loginBuilder
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
    contentView.logoutButton.rx.tap
      .subscribe(with: self) { `self`, _ in
        self.viewModel.logoutButtonTapped()
      }
      .disposed(by: disposeBag)
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
