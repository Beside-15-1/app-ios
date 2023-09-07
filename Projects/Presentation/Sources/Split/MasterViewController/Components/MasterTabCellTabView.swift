//
//  MasterTabCellTabView.swift
//  Presentation
//
//  Created by 박천송 on 2023/09/06.
//

import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem

class MasterTabCellTabView: UIView {

  enum ViewType: Hashable {
    case home
    case folder
    case mypage
  }

  // MARK: Constant

  private enum Metric {
    static let mainIcon = CGSize(width: 24.0, height: 24.0)
    static let dropdown = CGSize(width: 24.0, height: 24.0)
  }

  // MARK: UI

  private let icon = UIImageView()

  private let titleLabel = UILabel()

  private let dropdownIcon = UIImageView().then {
    $0.image = DesignSystemAsset.iconDown.image.withTintColor(.gray600)
  }


  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  // MARK: Configuring

  func configure(type: ViewType) {
    switch type {
    case .home:
      icon.image = DesignSystemAsset.iconHomeOutline.image.withTintColor(.gray700)
      titleLabel.attributedText = "홈".styled(font: .subTitleBold, color: .gray800)
      dropdownIcon.isHidden = true

    case .folder:
      icon.image = DesignSystemAsset.iconFolderOutline.image.withTintColor(.gray700)
      titleLabel.attributedText = "폴더".styled(font: .subTitleBold, color: .gray800)
      dropdownIcon.isHidden = false

    case .mypage:
      icon.image = DesignSystemAsset.iconPersonOutline.image.withTintColor(.gray700)
      titleLabel.attributedText = "내 정보".styled(font: .subTitleBold, color: .gray800)
      dropdownIcon.isHidden = true
    }
  }


  // MARK: Layout

  private func defineLayout() {
    [icon, titleLabel, dropdownIcon].forEach { addSubview($0) }

    icon.snp.makeConstraints {
      $0.left.equalToSuperview().inset(20.0)
      $0.centerY.equalToSuperview()
      $0.size.equalTo(Metric.mainIcon)
    }

    titleLabel.snp.makeConstraints {
      $0.left.equalTo(icon.snp.right).offset(16.0)
      $0.centerY.equalToSuperview()
    }

    dropdownIcon.snp.makeConstraints {
      $0.right.equalToSuperview().inset(20.0)
      $0.centerY.equalToSuperview()
      $0.size.equalTo(Metric.dropdown)
    }
  }
}
