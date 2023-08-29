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
    [masterDetailButton].forEach { addSubview($0) }

    masterDetailButton.snp.makeConstraints {
      $0.left.equalTo(safeAreaLayoutGuide).inset(20.0)
      $0.top.equalTo(safeAreaLayoutGuide).inset(8.0)
      $0.size.equalTo(28.0)
    }
  }
}
