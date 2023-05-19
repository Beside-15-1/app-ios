//
//  MypageViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/05/19.
//

import UIKit

import RxSwift

final class MypageViewController: UIViewController {
  // MARK: UI

  private lazy var contentView = MypageView()

  // MARK: Properties

  private let viewModel: MypageViewModel

  // MARK: Initializing

  init(viewModel: MypageViewModel) {
    self.viewModel = viewModel
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

  func bind(with viewModel: MypageViewModel) {}
}
