//
//  SelectFolderViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/04.
//

import UIKit

import ReactorKit
import RxSwift
import PanModal

import DesignSystem

final class SelectFolderViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = SelectFolderView()


  // MARK: Properties

  var disposeBag = DisposeBag()


  // MARK: Initializing

  init(reactor: SelectFolderViewReactor) {
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
  }


  // MARK: Binding

  func bind(reactor: SelectFolderViewReactor) {
    bindContent(with: reactor)
  }

  private func bindContent(with reactor: SelectFolderViewReactor) {
    reactor.state.map(\.folders)
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, folders in
        self.contentView.applyCollectionViewDataSource(
          by: folders,
          selectedFolder: reactor.currentState.selectedFolder
        )
      }
      .disposed(by: disposeBag)
  }
}


// MARK: PanModalPresentable

extension SelectFolderViewController: PanModalPresentable {
  var panScrollable: UIScrollView? {
    contentView.collectionView
  }

  var shortFormHeight: PanModalHeight {
    .contentHeightIgnoringSafeArea(298.0)
  }

  var longFormHeight: PanModalHeight {
    .contentHeightIgnoringSafeArea(506.0)
  }

  var cornerRadius: CGFloat {
    16.0
  }

  var panModalBackgroundColor: UIColor {
    .modalBackgorund
  }

  var showDragIndicator: Bool {
    true
  }

  var dragIndicatorBackgroundColor: UIColor {
    .paperCard
  }
}

