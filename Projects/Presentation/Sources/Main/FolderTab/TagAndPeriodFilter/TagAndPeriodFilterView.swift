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

protocol TagAndPeriodFilterViewDelegate: AnyObject {
  func tagAndPeriodFilterViewCloseButtonTapped()
  func tagAndPeriodFilterViewPeriodButtonTapped(type: LinkPeriodType)
}

final class TagAndPeriodFilterView: UIView {

  // MARK: UI

  private let titleView = TitleView().then {
    $0.title = "필터"
  }

  private lazy var selectPeriodView = SelectPeriodView().then {
    $0.delegate = self
  }

  private let periodInputView = PeriodInputView()

  private let addedTagView = AddedTagView()

  private let tagListView = TagAndPeriodTagListView()


  // MARK: Properties

  weak var delegate: TagAndPeriodFilterViewDelegate?


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .paperWhite

    defineLayout()

    titleView.onCloseAction = { [weak self] in
      self?.delegate?.tagAndPeriodFilterViewCloseButtonTapped()
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  func configureTagList(items: [TagAndPeriodTagListView.SectionItem]) {
    tagListView.applyDataSource(by: items)
  }


  // MARK: Layout

  private func defineLayout() {
    [titleView, selectPeriodView, periodInputView, addedTagView, tagListView].forEach { addSubview($0) }

    titleView.snp.makeConstraints {
      $0.left.top.right.equalToSuperview()
    }

    selectPeriodView.snp.makeConstraints {
      $0.top.equalTo(titleView.snp.bottom).offset(20.0)
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
      $0.bottom.equalToSuperview()
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}


// MARK: SelectPeriodViewDelegate

extension TagAndPeriodFilterView: SelectPeriodViewDelegate {
  func selectPeriodViewButtonTapped(type: LinkPeriodType) {
    delegate?.tagAndPeriodFilterViewPeriodButtonTapped(type: type)
  }
}
