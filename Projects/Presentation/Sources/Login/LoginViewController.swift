//
//  LoginViewController.swift
//  PresentationInterface
//
//  Created by 박천송 on 2023/04/27.
//

import Foundation

import UIKit

import RxCocoa
import RxSwift

final class LoginViewController: UIViewController {
  // MARK: Properties

  private let viewModel: LoginViewModel?
  private let disposeBag = DisposeBag()

  private let contentView = LoginView()

  // MARK: Initializing

  init(viewModel: LoginViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white

    bind()
  }

  override func loadView() {
    super.loadView()

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
  }
}
