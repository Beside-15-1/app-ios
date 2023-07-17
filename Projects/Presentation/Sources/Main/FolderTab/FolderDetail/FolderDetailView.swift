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

  private let colorBackground = UIView().then {
    $0.backgroundColor = .paperGray
  }

  let tabView = TabView()


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
    [colorBackground, tabView].forEach { addSubview($0) }

    colorBackground.snp.makeConstraints {
      $0.left.right.top.equalToSuperview()
      $0.height.equalTo(230.0)
    }

    tabView.snp.makeConstraints {
      $0.top.left.right.equalTo(safeAreaLayoutGuide)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
  
}
