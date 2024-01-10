//
//  TagAndPeriodFilterViewController.swift
//  Presentation
//
//  Created by 박천송 on 12/20/23.
//

import UIKit

import ReactorKit
import RxSwift

import PresentationInterface

final class TagAndPeriodFilterViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = TagAndPeriodFilterView()


  // MARK: Properties

  var disposeBag = DisposeBag()


  // MARK: Initializing

  init(reactor: TagAndPeriodFilterViewReactor) {
    defer { self.reactor = reactor }
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: View Life Cycle

  override func loadView() {
    view = contentView

    contentView.delegate = self
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    reactor?.action.onNext(.viewDidLoad)
  }


  // MARK: Binding

  func bind(reactor: TagAndPeriodFilterViewReactor) {
    bindContent(with: reactor)
  }

  private func bindContent(with reactor: TagAndPeriodFilterViewReactor) {
    reactor.state.map(\.tagListSectionItems)
      .subscribe(with: self) { `self`, items in
        self.contentView.configureTagList(items: items)
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.periodType)
      .subscribe(with: self) { `self`, type in
        self.contentView.configurePeriodType(type: type)
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.selectedTagList)
      .subscribe(with: self) { `self`, tagList in
        self.contentView.configureSelectedTagList(tagList: tagList)
      }
      .disposed(by: disposeBag)
  }
}


// MARK: - TagAndPeriodFilterViewDelegate

extension TagAndPeriodFilterViewController: TagAndPeriodFilterViewDelegate {
  func tagAndPeriodFilterViewCloseButtonTapped() {
    dismiss(animated: true)
  }

  func tagAndPeriodFilterViewPeriodButtonTapped(type: PeriodType) {
    reactor?.action.onNext(.changePeriodType(type))
  }

  func tagAndPeriodFilterView(didSelectRowAt indexPath: IndexPath) {
    reactor?.action.onNext(.tagItemTapped(index: indexPath.row))
  }

  func tagAndPeriodFilterViewRemoveButtonTapped(at index: Int) {
    reactor?.action.onNext(.selectedTagListRemoveButtonTapped(index: index))
  }
}
