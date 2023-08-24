//
//  ShareView.swift
//  ShareExtension
//
//  Created by 박천송 on 2023/08/17.
//

import UIKit

import SnapKit
import Then

import DesignSystem

final class ShareView: UIView {

  // MARK: UI

  let boxView = ShareBoxView()

  let handleView = UIView().then {
    $0.backgroundColor = .paperWhite
    $0.layer.cornerRadius = 3
  }

  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .clear

    defineLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(boxView)
    addSubview(handleView)

    boxView.snp.makeConstraints {
      $0.left.right.bottom.equalToSuperview()
    }

    handleView.snp.makeConstraints {
      $0.width.equalTo(48.0)
      $0.height.equalTo(6.0)
      $0.centerX.equalToSuperview()
      $0.bottom.equalTo(boxView.snp.top).offset(-4.0)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
