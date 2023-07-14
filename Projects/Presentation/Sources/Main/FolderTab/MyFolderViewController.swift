//
//  MyFolderViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/11.
//

import UIKit

import ReactorKit
import RxSwift


final class MyFolderViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = MyFolderView()


  // MARK: Properties

  var disposeBag = DisposeBag()


  // MARK: Initializing

  init(reactor: MyFolderViewReactor) {
    defer { self.reactor = reactor }
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
}
