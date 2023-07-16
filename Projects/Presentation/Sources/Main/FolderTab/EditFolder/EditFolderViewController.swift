//
//  EditFolderViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/14.
//

import UIKit

import PanModal
import ReactorKit
import RxSwift

import DesignSystem
import PresentationInterface

final class EditFolderViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = EditFolderView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  private let createFolderBuilder: CreateFolderBuildable

  weak var delegate: EditFolderDelegate?


  // MARK: Initializing

  init(
    reactor: EditFolderViewReactor,
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
  }


  // MARK: Binding

  func bind(reactor: EditFolderViewReactor) {
    bindContent(with: reactor)
    bindButton(with: reactor)
  }

  private func bindButton(with reactor: EditFolderViewReactor) {
    contentView.titleView.closeButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.dismiss(animated: true)
      }
      .disposed(by: disposeBag)

    contentView.modifyButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        guard let reactor = self.reactor else { return }
        self.dismiss(animated: true) {
          self.delegate?.editFolderModifyButtonTapped(withFolder: reactor.currentState.folder)
        }
      }
      .disposed(by: disposeBag)

    contentView.deleteButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        guard let reactor = self.reactor else { return }
        self.dismiss(animated: true) {
          self.delegate?.editFolderDeleteButtonTapped(withFolder: reactor.currentState.folder)
        }
      }
      .disposed(by: disposeBag)
  }

  private func bindContent(with reactor: EditFolderViewReactor) {
    reactor.state.map(\.folder)
      .asObservable()
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, folder in
        self.contentView.configureTitle(title: folder.title)
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
