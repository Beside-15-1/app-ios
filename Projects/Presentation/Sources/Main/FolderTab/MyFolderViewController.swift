//
//  MyFolderViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/11.
//

import UIKit

import ReactorKit
import RxSwift

import PresentationInterface

final class MyFolderViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = MyFolderView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  private let createFolderBuilder: CreateFolderBuildable


  // MARK: Initializing

  init(
    reactor: MyFolderViewReactor,
    createFolderBuilder: CreateFolderBuildable
  ) {
    defer { self.reactor = reactor }

    self.createFolderBuilder = createFolderBuilder

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func loadView() {
    view = contentView
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    reactor?.action.onNext(.viewDidLoad)
  }


  // MARK: Binding

  func bind(reactor: MyFolderViewReactor) {
    bindContent(with: reactor)
    bindTextField(with: reactor)
    bindButton(with: reactor)
  }

  private func bindContent(with reactor: MyFolderViewReactor) {
    reactor.state.compactMap(\.folderViewModel)
      .asObservable()
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, viewModel in
        self.contentView.myFolderCollectionView.applyCollectionViewDataSource(by: viewModel)
      }
      .disposed(by: disposeBag)
  }

  private func bindTextField(with reactor: MyFolderViewReactor) {
    contentView.folderSearchField.rx.text
      .subscribe(with: self) { `self`, text in
        reactor.action.onNext(.searchText(text))
        self.contentView.myFolderCollectionView.configureEmptyLabel(text: text)
      }
      .disposed(by: disposeBag)
  }

  private func bindButton(with reactor: MyFolderViewReactor) {
    contentView.myFolderCollectionView.createFolderButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        let vc = self.createFolderBuilder.build(payload: .init(
          folder: nil,
          delegate: self)
        ).then {
          $0.modalPresentationStyle = .popover
        }

        self.present(vc, animated: true)
      }
      .disposed(by: disposeBag)
  }
}


// MARK: CreateFolderDelegate

extension MyFolderViewController: CreateFolderDelegate {
  func createFolderSucceed() {
    reactor?.action.onNext(.createFolderSucceed)
  }
}
