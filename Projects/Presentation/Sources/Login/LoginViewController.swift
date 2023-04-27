//
//  LoginViewController.swift
//  PresentationInterface
//
//  Created by 박천송 on 2023/04/27.
//

import Foundation

import UIKit

final class LoginViewController: UIViewController {

  private let viewModel: LoginViewModel?

  private let contentView = LoginView()

  init(viewModel: LoginViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white
  }

  override func loadView() {
    super.loadView()

    self.view = contentView
  }
}
