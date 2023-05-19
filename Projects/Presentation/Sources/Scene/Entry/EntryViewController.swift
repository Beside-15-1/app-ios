//
//  EntryViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/05/19.
//

import UIKit

import RxSwift

import PresentationInterface

final class EntryViewController: UIViewController {
  // MARK: UI

  private lazy var contentView = EntryView()

  // MARK: Properties

  private let viewModel: EntryViewModel

  private let loginBuilder: LoginBuildable
  private let mainTabBuilder: MainTabBarBuildable

  // MARK: Initializing

  init(
    viewModel: EntryViewModel,
    loginBuilder: LoginBuildable,
    mainTabBuilder: MainTabBarBuildable
  ) {
    self.viewModel = viewModel
    self.loginBuilder = loginBuilder
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

    bind(with: viewModel)
  }

  // MARK: Binding

  func bind(with viewModel: EntryViewModel) {}
}
