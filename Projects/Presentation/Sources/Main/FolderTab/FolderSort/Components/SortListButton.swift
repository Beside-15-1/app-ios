//
//  SortListButton.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/16.
//

import UIKit

import SnapKit
import Then

import DesignSystem

final class SortListButton: UIControl {

  private let titleLabel = UILabel()
  private let selectIcon = UIImageView().then {
    $0.image = DesignSystemAsset.iconCheck.image.withTintColor(.primary500)
    $0.isHidden = true
  }

  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.backgroundColor = .clear
    self.layer.cornerRadius = 8
    self.clipsToBounds = true

    defineLayout()
  }

  func configureTitle(title: String) {
    titleLabel.attributedText = title.styled(font: .defaultSemiBold, color: .staticBlack)
  }

  func configureSelected(isSelected: Bool) {
    if isSelected {
      self.backgroundColor = .gray100
      self.selectIcon.isHidden = false
    } else {
      self.backgroundColor = .clear
      self.selectIcon.isHidden = true
    }

  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Layout

  private func defineLayout() {
    [titleLabel, selectIcon].forEach { addSubview($0) }

    self.snp.makeConstraints {
      $0.height.equalTo(48.0)
    }

    titleLabel.snp.makeConstraints {
      $0.left.equalToSuperview().inset(24.0)
      $0.centerY.equalToSuperview()
    }

    selectIcon.snp.makeConstraints {
      $0.right.equalToSuperview().inset(24.0)
      $0.centerY.equalToSuperview()
      $0.size.equalTo(24.0)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
