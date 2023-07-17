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

final class FolderDetailView: UIView {

  // MARK: UI

  private let safeAreaView = UIView().then {
    $0.backgroundColor = .paperAboveBg
  }

  private let colorBackground = UIView().then {
    $0.backgroundColor = .paperAboveBg
  }

  let tabView = TabView(colorType: .white)

  let searchField = InputField(type: .search).then {
    $0.placeHolder = "링크 제목으로 검색해보세요"
  }

  let listView = FolderDetailListView()


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.backgroundColor = .paperWhite

    defineLayout()
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


  // MARK: Layout

  private func defineLayout() {
    [safeAreaView, colorBackground, tabView, searchField, listView].forEach { addSubview($0) }

    safeAreaView.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
      $0.bottom.equalTo(safeAreaLayoutGuide.snp.top)
    }

    colorBackground.snp.makeConstraints {
      $0.left.right.top.equalTo(safeAreaLayoutGuide)
      $0.height.equalTo(200 - 44)
    }

    tabView.snp.makeConstraints {
      $0.top.left.right.equalTo(safeAreaLayoutGuide)
    }

    searchField.snp.makeConstraints {
      $0.top.equalTo(tabView.snp.bottom).offset(12.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    listView.snp.makeConstraints {
      $0.top.equalTo(colorBackground.snp.bottom)
      $0.left.right.equalToSuperview().inset(20.0)
      $0.bottom.equalTo(safeAreaLayoutGuide)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
  
}
