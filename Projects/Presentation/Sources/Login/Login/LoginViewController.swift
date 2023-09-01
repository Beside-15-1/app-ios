import AuthenticationServices
import Foundation
import UIKit

import PanModal
import RxCocoa
import RxSwift

import DesignSystem
import PresentationInterface

// MARK: - LoginViewController

final class LoginViewController: UIViewController {
  // MARK: Properties

  private let viewModel: LoginViewModel
  private let disposeBag = DisposeBag()
  private var transition: UIViewControllerAnimatedTransitioning?

  private let contentView = LoginView()

  private let mainTabBuilder: MainTabBarBuildable
  private let signUpBuilder: SignUpBuildable
  private let termsOfuseBuilder: TermsOfUseBuildable

  // MARK: Initializing

  init(
    viewModel: LoginViewModel,
    mainTabBuilder: MainTabBarBuildable,
    signUpBuilder: SignUpBuildable,
    termsOfUseBuilder: TermsOfUseBuildable
  ) {
    self.viewModel = viewModel
    self.mainTabBuilder = mainTabBuilder
    self.signUpBuilder = signUpBuilder
    termsOfuseBuilder = termsOfUseBuilder
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.delegate = self
    navigationController?.isNavigationBarHidden = true

    splitViewController?.preferredDisplayMode = .secondaryOnly

    bind(with: viewModel)
  }

  override func loadView() {
    view = contentView
  }

  // MARK: Binding

  private func bind(with viewModel: LoginViewModel) {
    bindButtons(with: viewModel)
    bindRoute(with: viewModel)
  }

  private func bindButtons(with viewModel: LoginViewModel) {
    contentView.googleButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.viewModel.googleLoginButtonTapped()
      }
      .disposed(by: disposeBag)

    contentView.appleButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { viewcontroller, _ in
        viewcontroller.viewModel.appleLoginButtonTapped()
      }
      .disposed(by: disposeBag)
  }

  private func bindRoute(with viewModel: LoginViewModel) {
    viewModel.isLoginSuccess
      .filter { $0 }
      .subscribe(with: self) { `self`, _ in
        let mainTab = self.mainTabBuilder.build(payload: .init())
        self.transition = FadeAnimator(animationDuration: 0.5, isPresenting: true)
        self.navigationController?.setViewControllers([mainTab], animated: true)
        self.splitViewController?.changeDisplayMode(to: .oneBesideSecondary)
        self.transition = nil
      }
      .disposed(by: disposeBag)

    viewModel.showTermsOfUse
      .filter { $0 }
      .subscribe(with: self) { `self`, _ in
        guard let termsOfUse = self.termsOfuseBuilder.build(payload: .init(
          delegate: self
        ))
          as? PanModalPresentable.LayoutType else { return }

        self.presentPanModalInIpad(termsOfUse)
      }
      .disposed(by: disposeBag)

    viewModel.needSignUp
      .subscribe(with: self) { `self`, data in
        let signUp = self.signUpBuilder
          .build(payload: .init(
            accessToken: data.0,
            social: data.1
          ))
        self.navigationController?.pushViewController(signUp, animated: true)
      }
      .disposed(by: disposeBag)
  }
}

// MARK: UINavigationControllerDelegate

extension LoginViewController: UINavigationControllerDelegate {
  func navigationController(
    _ navigationController: UINavigationController,
    animationControllerFor operation: UINavigationController.Operation,
    from fromVC: UIViewController,
    to toVC: UIViewController
  ) -> UIViewControllerAnimatedTransitioning? {
    transition
  }
}

// MARK: TermsOfUseDelegate

extension LoginViewController: TermsOfUseDelegate {
  func termsOfUseNextButtonTapped() {
    viewModel.termsOfUseNextButtonTapped()
  }
}
