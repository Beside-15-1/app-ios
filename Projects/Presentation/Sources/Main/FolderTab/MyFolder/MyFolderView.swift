//
//  MyFolderView.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/11.
//

import UIKit

import SnapKit
import Then

import DesignSystem

final class MyFolderView: UIView {

  // MARK: UI

  private let colorBackground = UIView().then {
    $0.backgroundColor = .paperAboveBg
  }

  private let titleLabel = UILabel().then {
    $0.attributedText = "내 폴더".styled(font: .titleBold, color: .white)
  }

  let folderSearchField = InputField(type: .normal).then {
    $0.placeHolder = "폴더명으로 검색해보세요"
  }

  let myFolderCollectionView = MyFolderCollectionView()


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .paperWhite

    defineLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Layout

  private func defineLayout() {
    [colorBackground, titleLabel, folderSearchField, myFolderCollectionView].forEach { addSubview($0) }

    colorBackground.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
      $0.height.equalTo(200)
    }

    titleLabel.snp.makeConstraints {
      $0.left.equalToSuperview().inset(20.0)
      $0.top.equalTo(safeAreaLayoutGuide).inset(24.0)
    }

    folderSearchField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(12.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    myFolderCollectionView.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(20.0)
      $0.top.equalTo(colorBackground.snp.bottom)
      $0.bottom.equalTo(safeAreaLayoutGuide)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)

    endEditing(true)
  }
}
