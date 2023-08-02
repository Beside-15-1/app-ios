//
//  LinkSortViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/18.
//

import UIKit

import ReactorKit
import RxSwift
import PanModal

import Domain
import PresentationInterface

final class LinkSortViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = LinkSortView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  weak var delegate: LinkSortDelegate?


  // MARK: Initializing

  init(reactor: LinkSortViewReactor) {
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

  func bind(reactor: LinkSortViewReactor) {
    contentView.createButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.dismiss(animated: true) {
          self.delegate?.linkSortListItemTapped(type: .createAt)
        }
      }
      .disposed(by: disposeBag)

    contentView.namingButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.dismiss(animated: true) {
          self.delegate?.linkSortListItemTapped(type: .title)
        }
      }
      .disposed(by: disposeBag)

    contentView.lastButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.dismiss(animated: true) {
          self.delegate?.linkSortListItemTapped(type: .lastedAt)
        }
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.sortType)
      .asObservable()
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, type in
        switch type {
        case .createAt:
          self.contentView.createButton.configureSelected(isSelected: true)
        case .title:
          self.contentView.namingButton.configureSelected(isSelected: true)
        case .updatedAt:
          break
        case .lastedAt:
          self.contentView.lastButton.configureSelected(isSelected: true)
        }
      }
      .disposed(by: disposeBag)
  }
}


// MARK: PanModalPresentable

extension LinkSortViewController: PanModalPresentable {
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

