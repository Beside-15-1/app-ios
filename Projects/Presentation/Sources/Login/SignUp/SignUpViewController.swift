import UIKit

import RxSwift
import ReactorKit

import PresentationInterface
import DesignSystem

// MARK: - SignUpViewController

final class SignUpViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = SignUpView()

  // MARK: Properties

  private var transition: UIViewControllerAnimatedTransitioning?

  private let mainTabBuilder: MainTabBarBuildable

  var disposeBag = DisposeBag()

  // MARK: Initializing

  init(
    reactor: SignUpViewReactor,
    mainTabBuilder: MainTabBarBuildable
  ) {
    defer { self.reactor = reactor }
    self.mainTabBuilder = mainTabBuilder
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
    navigationController?.delegate = self
    configureNavigationBar()
  }

  // MARK: Binding

  func bind(reactor: SignUpViewReactor) {}

  private func bindRoute(with reactor: SignUpViewReactor) {
//    viewModel.isSignUpSuccess
//      .filter { $0 }
//      .subscribe(with: self) { `self`, _ in
//        let mainTab = self.mainTabBuilder.build(payload: .init())
//        self.transition = FadeAnimator(animationDuration: 0.5, isPresenting: true)
//        self.navigationController?.setViewControllers([mainTab], animated: true)
//        self.transition = nil
//      }
//      .disposed(by: disposeBag)
  }


  // MARK: NavigationBar

  private func configureNavigationBar() {
    let backButton = UIBarButtonItem(
      image: DesignSystemAsset.iconLeft.image.withTintColor(.staticBlack),
      style: .plain,
      target: self,
      action: #selector(pop)
    )

    let passButton = UIBarButtonItem(
      title: "건너뛰기",
      style: .plain,
      target: self,
      action: #selector(passButtonTapped)
    )

    navigationItem.leftBarButtonItem = backButton
    navigationItem.leftBarButtonItem?.tintColor = .staticBlack
    navigationItem.title = "회원가입"
    navigationItem.rightBarButtonItem = passButton
    navigationItem.rightBarButtonItem?.tintColor = .gray700
    navigationItem.rightBarButtonItem?.setTitleTextAttributes([
      NSAttributedString.Key.font: UIFont.captionRegular
    ], for: .normal)
    navigationItem.rightBarButtonItem?.setTitleTextAttributes([
      NSAttributedString.Key.font: UIFont.captionRegular
    ], for: .highlighted)

    let attributes = [
      NSAttributedString.Key.foregroundColor: UIColor.staticBlack,
      NSAttributedString.Key.font: UIFont.defaultRegular
    ]
    navigationController?.navigationBar.titleTextAttributes = attributes
  }

  @objc
  private func pop() {
    navigationController?.popViewController(animated: true)
  }

  @objc
  private func passButtonTapped() {

  }
}

// MARK: UINavigationControllerDelegate

extension SignUpViewController: UINavigationControllerDelegate {
  func navigationController(
    _ navigationController: UINavigationController,
    animationControllerFor operation: UINavigationController.Operation,
    from fromVC: UIViewController,
    to toVC: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    transition
  }
}
