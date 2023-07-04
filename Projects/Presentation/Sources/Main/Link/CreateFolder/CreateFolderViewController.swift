//
//  CreateFolderViewController.swift
//  PresentationInterface
//
//  Created by Hohyeon Moon on 2023/06/01.
//

import UIKit

import RxSwift
import ReactorKit

final class CreateFolderViewController: UIViewController, StoryboardView {

  // MARK: UI

  private let contentView = CreateFolderView()

  // MARK: Properties

  var disposeBag = DisposeBag()

  // MARK: Initializing

  init(reactor: CreateFolderViewReactor) {
    defer { self.reactor = reactor }
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: View Life Cycle

  override func loadView() {
    super.loadView()

    self.view = contentView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: Binding

  func bind(reactor: CreateFolderViewReactor) {
    bindButtons(with: reactor)
  }

  private func bindButtons(with reactor: CreateFolderViewReactor) {
    contentView.titleView.closeButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.dismiss(animated: true)
      }
      .disposed(by: disposeBag)
  }
}
