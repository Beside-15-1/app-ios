//
//  FolderSortViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/16.
//

import UIKit

import ReactorKit
import RxSwift
import PanModal

import PresentationInterface


final class FolderSortViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = FolderSortView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  weak var delegate: FolderSortDelegate?


  // MARK: Initializing

  init(reactor: FolderSortViewReactor) {
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

  func bind(reactor: FolderSortViewReactor) {
    contentView.createButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.dismiss(animated: true) {
          self.delegate?.folderSortListItemTapped(type: .create)
        }
      }
      .disposed(by: disposeBag)

    contentView.namingButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.dismiss(animated: true) {
          self.delegate?.folderSortListItemTapped(type: .naming)
        }
      }
      .disposed(by: disposeBag)

    contentView.updateButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.dismiss(animated: true) {
          self.delegate?.folderSortListItemTapped(type: .update)
        }
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.sortType)
      .asObservable()
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, type in
        switch type {
        case .create:
          self.contentView.createButton.configureSelected(isSelected: true)
        case .naming:
          self.contentView.namingButton.configureSelected(isSelected: true)
        case .update:
          self.contentView.updateButton.configureSelected(isSelected: true)
        }
      }
      .disposed(by: disposeBag)

    contentView.titleView.closeButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.dismiss(animated: true)
      }
      .disposed(by: disposeBag)
  }
}


// MARK: PanModalPresentable

extension FolderSortViewController: PanModalPresentable {
  var panScrollable: UIScrollView? {
    nil
  }

  var shortFormHeight: PanModalHeight {
    .contentHeight(252)
  }

  var longFormHeight: PanModalHeight {
    .contentHeight(252)
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
