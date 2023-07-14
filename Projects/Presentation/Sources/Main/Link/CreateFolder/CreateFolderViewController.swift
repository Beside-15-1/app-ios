//
//  CreateFolderViewController.swift
//  PresentationInterface
//
//  Created by Hohyeon Moon on 2023/06/01.
//

import UIKit

import RxSwift
import ReactorKit

import PresentationInterface

final class CreateFolderViewController: UIViewController, StoryboardView {

  // MARK: UI

  private let contentView = CreateFolderView()

  // MARK: Properties

  var disposeBag = DisposeBag()

  weak var delegate: CreateFolderDelegate?

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

    contentView.linkBookTabView.colorView.delegate = self
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  // MARK: Binding

  func bind(reactor: CreateFolderViewReactor) {
    bindButtons(with: reactor)
    bindContent(with: reactor)
    bindTextField(with: reactor)
    bindRoute(with: reactor)
  }

  private func bindButtons(with reactor: CreateFolderViewReactor) {
    contentView.titleView.closeButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.dismiss(animated: true)
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.isMakeButtonEnabled)
      .distinctUntilChanged()
      .asObservable()
      .bind(to: contentView.linkBookTabView.makeButton.rx.isEnabled)
      .disposed(by: disposeBag)

    contentView.linkBookTabView.makeButton.rx.controlEvent(.touchUpInside)
      .map { Reactor.Action.makeButtonTapped }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  private func bindContent(with reactor: CreateFolderViewReactor) {

    reactor.state.map(\.backgroundColors)
      .distinctUntilChanged()
      .asObservable()
      .subscribe(with: self) { `self`, colors in
        self.contentView.linkBookTabView.colorView.configureBackground(
          colors: colors,
          selectedColor: reactor.currentState.viewModel.backgroundColor
        )
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.titleColors)
      .distinctUntilChanged()
      .asObservable()
      .subscribe(with: self) { `self`, colors in
        self.contentView.linkBookTabView.colorView.configureTitleColor(
          colors: colors,
          selectedColor: reactor.currentState.viewModel.titleColor
        )
      }
      .disposed(by: disposeBag)

    reactor.state.compactMap(\.folder)
      .distinctUntilChanged()
      .asObservable()
      .subscribe(with :self) { `self`, folder in
        self.contentView.linkBookTabView.folderView.inputField.text = folder.title
        self.contentView.titleView.title = "폴더 수정"
        self.contentView.linkBookTabView.makeButton.text = "변경하기"
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.viewModel)
      .distinctUntilChanged()
      .asObservable()
      .subscribe(with: self) { `self`, viewModel in
        self.contentView.previewView.configure(with: viewModel)
      }
      .disposed(by: disposeBag)
  }

  private func bindTextField(with reactor: CreateFolderViewReactor) {
    contentView.linkBookTabView.folderView.inputField.rx.text
      .skip(1)
      .map { Reactor.Action.updateTitle($0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  private func bindRoute(with reactor: CreateFolderViewReactor) {
    reactor.state.map(\.isSuccess)
      .distinctUntilChanged()
      .filter { $0 }
      .subscribe(with: self) { `self`, _ in
        self.dismiss(animated: true) {
          self.delegate?.createFolderSucceed()
        }
      }
      .disposed(by: disposeBag)
  }
}


// MARK: - CreateFolderColorViewDelegate

extension CreateFolderViewController: CreateFolderColorViewDelegate {
  func backgroundColorDidTap(at row: Int) {
    reactor?.action.onNext(.updateBackgroundColor(row))
  }

  func titleColorDidTap(at row: Int) {
    reactor?.action.onNext(.updateTitleColor(row))
  }
}
