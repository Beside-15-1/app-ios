//
//  EditFolderView.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/14.
//

import UIKit

import SnapKit
import Then

import DesignSystem

final class EditFolderView: UIView {

  // MARK: UI

  let titleView = TitleView()

  private let modifyButton = EditFolderModifyButton()

  private let deleteButton = EditFolderDeleteButton()


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .paperWhite

    defineLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  func configureTitle(title: String) {
    titleView.title = title
  }


  // MARK: Layout

  private func defineLayout() {
    [titleView, modifyButton, deleteButton].forEach {
      addSubview($0)
    }

    titleView.snp.makeConstraints {
      $0.left.right.top.equalToSuperview()
    }

    modifyButton.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(20.0)
      $0.top.equalTo(titleView.snp.bottom).offset(12.0)
    }

    deleteButton.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(20.0)
      $0.top.equalTo(modifyButton.snp.bottom).offset(4.0)
      $0.bottom.equalTo(safeAreaLayoutGuide).inset(28.0)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
