//
//  TagAndPeriodFilterView.swift
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

protocol TagAndPeriodFilterViewDelegate: AnyObject {
  func tagAndPeriodFilterViewCloseButtonTapped()
  func tagAndPeriodFilterViewPeriodButtonTapped(type: PeriodType)
  func tagAndPeriodFilterView(didSelectRowAt indexPath: IndexPath)
  func tagAndPeriodFilterViewRemoveButtonTapped(at index: Int)
  func tagAndPeriodFilterViewCustomPeriodChanged(customPeriod: CustomPeriod)
  func tagAndPeriodFilterViewConfirmButtonTapped()
  func tagAndPeriodFilterViewResetButtonTapped()
  func tagAndPeriodFilterViewUnreadFilterValueChanged(isOn: Bool)
}

final class TagAndPeriodFilterView: UIView {

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

  private lazy var tagListView = TagAndPeriodTagListView().then {
    $0.delegate = self
  }

  private let resetButton = TagAndPeriodFilterResetButton()

  private let confirmButton = BasicButton(priority: .primary).then {
    $0.text = "확인"
  }


  // MARK: Properties

  weak var delegate: TagAndPeriodFilterViewDelegate?


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
      self?.delegate?.tagAndPeriodFilterViewCloseButtonTapped()
    }

    confirmButton.addAction(UIAction(handler: { [weak self] _ in
      self?.delegate?.tagAndPeriodFilterViewConfirmButtonTapped()
    }), for: .touchUpInside)

    resetButton.addAction(UIAction(handler: { [weak self] _ in
      self?.delegate?.tagAndPeriodFilterViewResetButtonTapped()
    }), for: .touchUpInside)
  }


  // MARK: Configuring

  func configureTagList(items: [TagAndPeriodTagListView.SectionItem]) {
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

extension TagAndPeriodFilterView: SelectPeriodViewDelegate {
  func selectPeriodViewButtonTapped(type: PeriodType) {
    delegate?.tagAndPeriodFilterViewPeriodButtonTapped(type: type)
  }
}


// MARK: TagAndPeriodListViewDelegate

extension TagAndPeriodFilterView: TagAndPeriodListViewDelegate {
  func tagListView(_ listView: TagAndPeriodTagListView, didSelectRowAt indexPath: IndexPath) {
    delegate?.tagAndPeriodFilterView(didSelectRowAt: indexPath)
  }
}


// MARK: AddedTagViewDelegate

extension TagAndPeriodFilterView: AddedTagViewDelegate {
  func removeAddedTag(at row: Int) {
    delegate?.tagAndPeriodFilterViewRemoveButtonTapped(at: row)
  }
}


// MARK: CustomPeriod

extension TagAndPeriodFilterView: PeriodInputViewDelegate {
  func periodInputView(customPeriod: CustomPeriod) {
    delegate?.tagAndPeriodFilterViewCustomPeriodChanged(customPeriod: customPeriod)
  }
}


// MARK: TagAndPeriodUnreadFilterDelegate

extension TagAndPeriodFilterView: TagAndPeriodUnreadFilterViewDelegate {
  func tagAndPeriodUnreadFilterViewSwitchValueChanged(isOn: Bool) {
    delegate?.tagAndPeriodFilterViewUnreadFilterValueChanged(isOn: isOn)
  }
}
