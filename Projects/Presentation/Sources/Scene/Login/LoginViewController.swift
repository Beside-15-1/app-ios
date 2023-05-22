//
//  LoginViewController.swift
//  PresentationInterface
//
//  Created by 박천송 on 2023/04/27.
//

import AuthenticationServices
import Foundation
import UIKit

import RxCocoa
import RxSwift

import PresentationInterface

// MARK: - LoginViewController

final class LoginViewController: UIViewController {
  // MARK: Properties

  private let viewModel: LoginViewModel?
  private let disposeBag = DisposeBag()
  private var transition: UIViewControllerAnimatedTransitioning?

  private let contentView = LoginView()

  private let mainTabBuilder: MainTabBarBuildable

  // MARK: Initializing

  init(
    viewModel: LoginViewModel,
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

  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.delegate = self
    bind()
  }

  override func loadView() {
    view = contentView
  }

  // MARK: Binding

  private func bind() {
    bindButtons()
  }

  private func bindButtons() {
    contentView.googleButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.viewModel?.googleLoginButtonTapped()
      }
      .disposed(by: disposeBag)

    contentView.appleButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { viewcontroller, _ in
        viewcontroller.viewModel?.appleLoginButtonTapped()
      }
      .disposed(by: disposeBag)

    contentView.testButton.rx.tap
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
