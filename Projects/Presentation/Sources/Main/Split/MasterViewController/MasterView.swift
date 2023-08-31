//
//  MasterView.swift
//  Presentation
//
//  Created by 박천송 on 2023/08/28.
//

import UIKit

import SnapKit
import Then

import DesignSystem

final class MasterView: UIView {

  // MARK: UI

  let masterDetailButton = UIButton().then {
    $0.setImage(DesignSystemAsset.iconMasterDetail.image.withTintColor(.staticBlack), for: .normal)
  }

  let homeButton = UIButton().then {
    $0.setTitle("Home", for: .normal)
  }

  let folderButton = UIButton().then {
    $0.setTitle("Folder", for: .normal)
  }

  let myPageButton = UIButton().then {
    $0.setTitle("MyPage", for: .normal)
  }


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .paperGray

    defineLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()
  }

  private func defineLayout() {
    [masterDetailButton, homeButton, folderButton, myPageButton].forEach { addSubview($0) }

    masterDetailButton.snp.makeConstraints {
      $0.left.equalTo(safeAreaLayoutGuide).inset(20.0)
      $0.top.equalTo(safeAreaLayoutGuide).inset(8.0)
      $0.size.equalTo(28.0)
    }

    homeButton.snp.makeConstraints {
      $0.left.right.equalTo(safeAreaLayoutGuide).inset(20.0)
      $0.top.equalTo(masterDetailButton.snp.bottom).offset(50.0)
      $0.height.equalTo(44.0)
    }

    folderButton.snp.makeConstraints {
      $0.left.right.equalTo(safeAreaLayoutGuide).inset(20.0)
      $0.top.equalTo(homeButton.snp.bottom).offset(50.0)
      $0.height.equalTo(44.0)
    }

    myPageButton.snp.makeConstraints {
      $0.left.right.equalTo(safeAreaLayoutGuide).inset(20.0)
      $0.top.equalTo(folderButton.snp.bottom).offset(50.0)
      $0.height.equalTo(44.0)
    }
  }
}
