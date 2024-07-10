//
//  HomeFeedMoreCell.swift
//  Presentation
//
//  Created by 박천송 on 6/25/24.
//

import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem


class HomeFeedMoreCell: UICollectionViewCell {

  static let identifier = "HomeFeedMoreCell"

  // MARK: UI

  private let flexContainer = UIView().then {
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
    $0.backgroundColor = .paperWhite
  }

  private let contentContainer = UIView()
  private let titleLabel = UILabel().then {
    $0.attributedText = "저장한 링크 모두 보기".styled(font: .bodyBold, color: .gray700)
  }

  private let chevronIcon = UIImageView().then {
    $0.image = DesignSystemAsset.iconRight.image.withTintColor(.gray700)
  }


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Layout

  private func defineLayout() {
    contentView.addSubview(flexContainer)
    flexContainer.addSubview(contentContainer)
    contentContainer.addSubview(titleLabel)
    contentContainer.addSubview(chevronIcon)

    flexContainer.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.left.right.equalToSuperview().inset(20.0)
    }

    contentContainer.snp.makeConstraints {
      $0.center.equalToSuperview()
    }

    titleLabel.snp.makeConstraints {
      $0.left.top.bottom.equalToSuperview()
    }

    chevronIcon.snp.makeConstraints {
      $0.right.equalToSuperview()
      $0.left.equalTo(titleLabel.snp.right)
      $0.centerY.equalTo(titleLabel.snp.centerY)
      $0.size.equalTo(20.0)
    }
  }
}

