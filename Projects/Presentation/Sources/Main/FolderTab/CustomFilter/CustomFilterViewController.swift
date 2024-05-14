//
//  CustomFilterViewController.swift
//  Presentation
//
//  Created by 박천송 on 12/20/23.
//

import UIKit

import ReactorKit
import RxSwift

import DesignSystem
import Domain
import PresentationInterface

final class CustomFilterViewController: UIViewController, StoryboardView {

  // MARK: UI

  private lazy var contentView = CustomFilterView()


  // MARK: Properties

  var disposeBag = DisposeBag()

  weak var delegate: CustomFilterDelegate?


  // MARK: Initializing

  init(reactor: CustomFilterViewReactor) {
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

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    reactor?.action.onNext(.viewDidAppear)
  }


  // MARK: Binding

  func bind(reactor: CustomFilterViewReactor) {
    bindContent(with: reactor)
  }

  private func bindContent(with reactor: CustomFilterViewReactor) {
    reactor.state.map(\.tagListSectionItems)
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, items in
        self.contentView.configureTagList(items: items)
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.periodType)
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, type in
        self.contentView.configurePeriodType(type: type)
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.selectedTagList)
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, tagList in
        self.contentView.configureSelectedTagList(tagList: tagList)
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.customPeriod)
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, period in
        self.contentView.configureDate(customPeriod: period)
      }
      .disposed(by: disposeBag)

    reactor.state.map(\.isUnreadFiltering)
      .distinctUntilChanged()
      .subscribe(with: self) { `self`, isOn in
        self.contentView.configureUnreadFilter(isOn: isOn)
      }
      .disposed(by: disposeBag)
  }
}


// MARK: - CustomFilterViewDelegate

extension CustomFilterViewController: CustomFilterViewDelegate {
  func customFilterViewCloseButtonTapped() {
    reactor?.action.onNext(.closeButtonTapped)
    dismiss(animated: true)
  }

  func customFilterViewPeriodButtonTapped(type: PeriodType) {
    reactor?.action.onNext(.changePeriodType(type))
  }

  func customFilterView(didSelectRowAt indexPath: IndexPath) {
    reactor?.action.onNext(.tagItemTapped(index: indexPath.row))
  }

  func customFilterViewRemoveButtonTapped(at index: Int) {
    reactor?.action.onNext(.selectedTagListRemoveButtonTapped(index: index))
  }

  func customFilterViewCustomPeriodChanged(customPeriod: CustomPeriod) {
    reactor?.action.onNext(.updateCustomPeriod(customPeriod))
  }

  func customFilterViewConfirmButtonTapped() {
    guard let reactor else { return }
    reactor.action.onNext(.confirmButtonTapped)
    dismiss(animated: true) {
      self.delegate?.customFilterConfirmButtonTapped(
        customFilter: .init(
          isUnreadFiltering: reactor.currentState.isUnreadFiltering,
          periodType: reactor.currentState.periodType,
          customPeriod: reactor.currentState.customPeriod,
          selectedTagList: reactor.currentState.selectedTagList
        )
      )
    }
  }

  func customFilterViewResetButtonTapped() {
    PBDialog(title: "필터를 초기화 하시겠어요?", content: "선택한 날짜, 태그 조건이 모두 해제됩니다.", from: self)
      .addAction(content: "취소", priority: .secondary, action: nil)
      .addAction(content: "확인", priority: .primary, action: { [weak self] in
        self?.dismiss(animated: true) {
          self?.reactor?.action.onNext(.resetButtonTapped)
          self?.delegate?.customFilterResetButtonTapped()
        }
      })
      .show()
  }

  func customFilterViewUnreadFilterValueChanged(isOn: Bool) {
    reactor?.action.onNext(.updateUnreadFiltering(isOn))
  }
}
