//
//  FolderSortView.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/16.
//

import UIKit

import SnapKit
import Then

import DesignSystem
import PresentationInterface

final class FolderSortView: UIView {

  private let titleView = TitleView().then {
    $0.title = "옵션 선택"
  }

  private let buttonStackView = UIStackView().then {
    $0.axis = .vertical
    $0.distribution = .fillEqually
    $0.spacing = 4
  }

  let createButton = SortListButton().then {
    $0.configureTitle(title: FolderSortModel.create.rawValue)
  }

  let namingButton = SortListButton().then {
    $0.configureTitle(title: FolderSortModel.naming.rawValue)
  }

  let updateButton = SortListButton().then {
    $0.configureTitle(title: FolderSortModel.update.rawValue)
  }


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.backgroundColor = .paperWhite

    defineLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Layout

  private func defineLayout() {
    [titleView, buttonStackView].forEach { addSubview($0) }
    [createButton, namingButton, updateButton].forEach { buttonStackView.addArrangedSubview($0) }

    titleView.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
    }

    buttonStackView.snp.makeConstraints {
      $0.top.equalTo(titleView.snp.bottom).offset(12.0)
      $0.left.right.equalToSuperview().inset(12.0)
      $0.bottom.equalTo(safeAreaLayoutGuide).inset(28.0)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
