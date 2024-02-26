//
//  CustomFilterView.swift
//  Presentation
//
//  Created by 박천송 on 12/20/23.
//

import UIKit

import SnapKit
import Then

import DesignSystem
import Domain
import PresentationInterface

protocol CustomFilterViewDelegate: AnyObject {
  func customFilterViewCloseButtonTapped()
  func customFilterViewPeriodButtonTapped(type: PeriodType)
  func customFilterView(didSelectRowAt indexPath: IndexPath)
  func customFilterViewRemoveButtonTapped(at index: Int)
  func customFilterViewCustomPeriodChanged(customPeriod: CustomPeriod)
  func customFilterViewConfirmButtonTapped()
  func customFilterViewResetButtonTapped()
  func customFilterViewUnreadFilterValueChanged(isOn: Bool)
}

final class CustomFilterView: UIView {

  // MARK: UI

  private let titleView = TitleView().then {
    $0.title = "필터"
  }

  private lazy var unreadFilterView = TagAndPeriodUnreadFilterView().then {
    $0.delegate = self
  }

  private lazy var selectPeriodView = SelectPeriodView().then {
    $0.delegate = self
  }

  private lazy var periodInputView = PeriodInputView().then {
    $0.delegate = self
  }

  private lazy var addedTagView = AddedTagView().then {
    $0.delegate = self
  }

  private lazy var tagListView = CustomFilterTagListView().then {
    $0.delegate = self
  }

  private let resetButton = CustomFilterResetButton()

  private let confirmButton = BasicButton(priority: .primary).then {
    $0.text = "확인"
  }


  // MARK: Properties

  weak var delegate: CustomFilterViewDelegate?


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .paperWhite

    defineLayout()
    addAction()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Action

  private func addAction() {
    titleView.onCloseAction = { [weak self] in
      self?.delegate?.customFilterViewCloseButtonTapped()
    }

    confirmButton.addAction(UIAction(handler: { [weak self] _ in
      self?.delegate?.customFilterViewConfirmButtonTapped()
    }), for: .touchUpInside)

    resetButton.addAction(UIAction(handler: { [weak self] _ in
      self?.delegate?.customFilterViewResetButtonTapped()
    }), for: .touchUpInside)
  }


  // MARK: Configuring

  func configureTagList(items: [CustomFilterTagListView.SectionItem]) {
    tagListView.applyDataSource(by: items)
  }

  func configureSelectedTagList(tagList: [String]) {
    addedTagView.applyAddedTag(by: tagList)
  }

  func configurePeriodType(type: PeriodType) {
    selectPeriodView.configurePeriodButton(type: type)
    if type == .custom {
      periodInputView.isHidden = false

      addedTagView.snp.remakeConstraints {
        $0.top.equalTo(periodInputView.snp.bottom).offset(32.0)
        $0.left.right.equalToSuperview().inset(20.0)
      }
    } else {
      periodInputView.isHidden = true

      addedTagView.snp.remakeConstraints {
        $0.top.equalTo(selectPeriodView.snp.bottom).offset(32.0)
        $0.left.right.equalToSuperview().inset(20.0)
      }
    }
  }

  func configureDate(customPeriod: CustomPeriod) {
    periodInputView.configureDate(startDate: customPeriod.startDate, endDate: customPeriod.endDate)
  }

  func configureUnreadFilter(isOn: Bool) {
    unreadFilterView.configureFilter(isOn: isOn)
  }


  // MARK: Layout

  private func defineLayout() {
    [
      titleView,
      unreadFilterView,
      selectPeriodView,
      periodInputView,
      addedTagView,
      tagListView,
      resetButton,
      confirmButton,
    ].forEach { addSubview($0) }

    titleView.snp.makeConstraints {
      $0.left.top.right.equalToSuperview()
    }

    unreadFilterView.snp.makeConstraints {
      $0.top.equalTo(titleView.snp.bottom).offset(20.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    selectPeriodView.snp.makeConstraints {
      $0.top.equalTo(unreadFilterView.snp.bottom).offset(32.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    periodInputView.snp.makeConstraints {
      $0.top.equalTo(selectPeriodView.snp.bottom).offset(32.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    addedTagView.snp.makeConstraints {
      $0.top.equalTo(periodInputView.snp.bottom).offset(32.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    tagListView.snp.makeConstraints {
      $0.top.equalTo(addedTagView.snp.bottom).offset(12.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    resetButton.snp.makeConstraints {
      $0.left.equalToSuperview().inset(20.0)
      $0.top.equalTo(tagListView.snp.bottom).offset(10.0)
      $0.bottom.equalTo(safeAreaLayoutGuide)
    }

    confirmButton.snp.makeConstraints {
      $0.left.equalTo(resetButton.snp.right).offset(8.0)
      $0.right.equalToSuperview().inset(20.0)
      $0.top.equalTo(tagListView.snp.bottom).offset(10.0)
      $0.bottom.equalTo(safeAreaLayoutGuide)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}


// MARK: SelectPeriodViewDelegate

extension CustomFilterView: SelectPeriodViewDelegate {
  func selectPeriodViewButtonTapped(type: PeriodType) {
    delegate?.customFilterViewPeriodButtonTapped(type: type)
  }
}


// MARK: TagAndPeriodListViewDelegate

extension CustomFilterView: TagAndPeriodListViewDelegate {
  func tagListView(_ listView: CustomFilterTagListView, didSelectRowAt indexPath: IndexPath) {
    delegate?.customFilterView(didSelectRowAt: indexPath)
  }
}


// MARK: AddedTagViewDelegate

extension CustomFilterView: AddedTagViewDelegate {
  func removeAddedTag(at row: Int) {
    delegate?.customFilterViewRemoveButtonTapped(at: row)
  }
}


// MARK: CustomPeriod

extension CustomFilterView: PeriodInputViewDelegate {
  func periodInputView(customPeriod: CustomPeriod) {
    delegate?.customFilterViewCustomPeriodChanged(customPeriod: customPeriod)
  }
}


// MARK: TagAndPeriodUnreadFilterDelegate

extension CustomFilterView: TagAndPeriodUnreadFilterViewDelegate {
  func tagAndPeriodUnreadFilterViewSwitchValueChanged(isOn: Bool) {
    delegate?.customFilterViewUnreadFilterValueChanged(isOn: isOn)
  }
}
