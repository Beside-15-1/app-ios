//
//  MoveFolderViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/19.
//

import UIKit

import PanModal
import ReactorKit
import RxSwift

import PresentationInterface

final class MoveFolderViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = MoveFolderView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  weak var delegate: MoveFolderDelegate?

  // MARK: Initializing

  init(
    reactor: MoveFolderViewReactor
  ) {
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

    contentView.delegate = self
  }


  // MARK: Binding

  func bind(reactor: MoveFolderViewReactor) {
    bindButton(with: reactor)
    bindContent(with: reactor)
  }

  private func bindButton(with reactor: MoveFolderViewReactor) {
    contentView.titleView.closeButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.dismiss(animated: true)
      }
      .disposed(by: disposeBag)

    contentView.saveButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.dismiss(animated: true) {
          self.delegate?.moveFolderSuccess(folder: reactor.currentState.folderList[reactor.currentState.selectedIndex])
        }
      }
      .disposed(by: disposeBag)
  }

  private func bindContent(with reactor: MoveFolderViewReactor) {
    reactor.state.compactMap(\.viewModel)
      .subscribe(with: self) { `self`, viewModel in
        self.contentView.applyCollectionViewDataSource(by: viewModel)
      }
      .disposed(by: disposeBag)
  }
}


// MARK: PanModalPresentable

extension MoveFolderViewController: PanModalPresentable {
  var panScrollable: UIScrollView? {
    nil
  }

  var shortFormHeight: PanModalHeight {
    .contentHeight(333)
  }

  var longFormHeight: PanModalHeight {
    .contentHeight(333)
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
    .paperWhite
  }
}


extension MoveFolderViewController: MoveFolderViewDelegate {
  func collectionView(didSelectItemAt indexPath: IndexPath) {
    reactor?.action.onNext(.itemTapped(row: indexPath.row))
  }
}
