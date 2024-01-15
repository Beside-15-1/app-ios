//
//  TagAndPeriodFilterResetButton.swift
//  Presentation
//
//  Created by 박천송 on 1/10/24.
//

import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem

final class TagAndPeriodFilterResetButton: UIButton {

  // MARK: UI

  private let icon = UIImageView().then {
    $0.image = DesignSystemAsset.iconReset.image.withTintColor(.gray700)
  }


  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    layer.cornerRadius = 8
    layer.borderWidth = 1
    layer.borderColor = UIColor.gray400.cgColor
    clipsToBounds = true
    backgroundColor = .clear

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(icon)
    icon.snp.makeConstraints {
      $0.size.equalTo(20.0)
      $0.center.equalToSuperview()
    }

    snp.makeConstraints {
      $0.size.equalTo(56.0)
    }
  }
}
