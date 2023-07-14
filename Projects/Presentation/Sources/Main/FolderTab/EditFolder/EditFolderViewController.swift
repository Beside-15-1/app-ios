//
//  EditFolderViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/14.
//

import UIKit

import ReactorKit
import RxSwift
import PanModal


final class EditFolderViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = EditFolderView()


  // MARK: Properties

  var disposeBag = DisposeBag()


  // MARK: Initializing

  init(reactor: EditFolderViewReactor) {
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

  func bind(reactor: EditFolderViewReactor) {
    bindContent(with: reactor)
  }

  private func bindContent(with reactor: EditFolderViewReactor) {
    reactor.state.map(\.folder)
      .asObservable()
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, folder in
        self.contentView.configureTitle(title: folder.title)
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

extension EditFolderViewController: PanModalPresentable {
  var panScrollable: UIScrollView? {
    nil
  }

  var shortFormHeight: PanModalHeight {
    .contentHeight(200)
  }

  var longFormHeight: PanModalHeight {
    .contentHeight(200)
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
