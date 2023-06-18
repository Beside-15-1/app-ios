import UIKit

import RxSwift

import PresentationInterface

// MARK: - SignUpViewController

final class SignUpViewController: UIViewController {
  // MARK: UI

  private lazy var contentView = SignUpView()

  // MARK: Properties

  private let viewModel: SignUpViewModel
  private var transition: UIViewControllerAnimatedTransitioning?

  private let mainTabBuilder: MainTabBarBuildable

  private let disposeBag = DisposeBag()

  // MARK: Initializing

  init(
    viewModel: SignUpViewModel,
    mainTabBuilder: MainTabBarBuildable
  ) {
    self.viewModel = viewModel
    self.mainTabBuilder = mainTabBuilder
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private let tf = UITextField()

  // MARK: View Life Cycle

  override func loadView() {
    view = contentView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.delegate = self
    bind(with: viewModel)
  }

  // MARK: Binding

  func bind(with viewModel: SignUpViewModel) {
    bindTextField(with: viewModel)
    bindRoute(with: viewModel)
  }

  private func bindTextField(with viewModel: SignUpViewModel) {
    contentView.nicknameTextField.rx.text
      .bind(to: viewModel.inputNickname)
      .disposed(by: disposeBag)

    contentView.genderTextField.rx.text
      .bind(to: viewModel.inputGender)
      .disposed(by: disposeBag)

    contentView.ageTextField.rx.text
      .bind(to: viewModel.inputAge)
      .disposed(by: disposeBag)

    contentView.signUpButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.viewModel.signUpButtonTapped()
      }
      .disposed(by: disposeBag)

    viewModel.isButtonEnabled
      .bind(to: contentView.signUpButton.rx.isEnabled)
      .disposed(by: disposeBag)
  }

  private func bindRoute(with viewModel: SignUpViewModel) {
    viewModel.isSignUpSuccess
      .filter { $0 }
      .subscribe(with: self) { `self`, _ in
        let mainTab = self.mainTabBuilder.build(payload: .init())
        self.transition = FadeAnimator(animationDuration: 0.5, isPresenting: true)
        self.navigationController?.setViewControllers([mainTab], animated: true)
        self.transition = nil
      }
      .disposed(by: disposeBag)
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
