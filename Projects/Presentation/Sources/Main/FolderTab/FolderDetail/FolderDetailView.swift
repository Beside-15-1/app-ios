//
//  FolderDetailView.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/17.
//

import UIKit

import SnapKit
import Then

import DesignSystem
import Domain

protocol FolderDetailViewDelegate: AnyObject {
  func filterChipTapped()
}

final class FolderDetailView: UIView {

  // MARK: UI

  private let safeAreaView = UIView().then {
    $0.backgroundColor = .paperAboveBg
  }

  private let colorBackground = UIView().then {
    $0.backgroundColor = .paperAboveBg
  }

  let tabView = WhiteTabView()

  let searchField = InputField(type: .normal).then {
    $0.placeHolder = "링크 제목으로 검색해보세요"
  }

  let filterChipView = FilterChipView()

  let listView = FolderDetailListView()

  let fab = FAB().then {
    $0.expand()
  }


  weak var delegate: FolderDetailViewDelegate?


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.backgroundColor = .paperWhite

    defineLayout()

    filterChipView.delegate = self
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  func configureTabs(by folderList: [Folder]) {
    tabView.applyTabs(by: folderList.map { $0.title })
  }

  func tabViewSelectItem(at row: Int) {
    tabView.selectItem(at: row)
  }

  func configureSearchField(isEnabled: Bool) {
    searchField.isEnabled = isEnabled
  }

  func configureFilterChip(items: [FilterChipView.SectionItem]) {
    filterChipView.applyChips(by: items)
  }

  // MARK: Layout

  private func defineLayout() {
    [
      safeAreaView,
      colorBackground,
      tabView,
      searchField,
      listView,
      filterChipView,
    ].forEach { addSubview($0) }

    safeAreaView.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
      $0.bottom.equalTo(safeAreaLayoutGuide.snp.top)
    }

    colorBackground.snp.makeConstraints {
      $0.left.right.top.equalTo(safeAreaLayoutGuide)
      $0.bottom.equalTo(searchField.snp.bottom).offset(38.0)
    }

    tabView.snp.makeConstraints {
      $0.top.left.right.equalTo(safeAreaLayoutGuide)
    }

    searchField.snp.makeConstraints {
      $0.top.equalTo(tabView.snp.bottom).offset(12.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    filterChipView.snp.makeConstraints {
      $0.top.equalTo(colorBackground.snp.bottom).offset(16.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    listView.snp.makeConstraints {
      $0.top.equalTo(filterChipView.snp.bottom).offset(3.0)
      $0.left.right.equalToSuperview().inset(20.0)
      $0.bottom.equalTo(safeAreaLayoutGuide)
    }

    addSubview(fab)

    fab.snp.makeConstraints {
      $0.right.equalToSuperview().inset(20.0)
      $0.bottom.equalTo(safeAreaLayoutGuide).inset(12.0)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }

}


// MARK: FilterChipViewDelegate

extension FolderDetailView: FilterChipViewDelegate {
  func filterChipTapped() {
    delegate?.filterChipTapped()
  }
}
