//
//  FilterChipCell.swift
//  DesignSystem
//
//  Created by 박천송 on 2/22/24.
//  Copyright © 2024 PinkBoss Inc. All rights reserved.
//

import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem

class FilterChipCell: UICollectionViewCell {
  static let identifier = "FilterChipCell"

  struct ViewModel: Hashable {
    let title: String
    let isFiltered: Bool
  }


  // MARK: Contants

  private enum Color {
    static let deselectedBackgroundColor = UIColor.paperWhite
    static let deselectedBorderColor = UIColor.gray300
    static let selectedBackgroundColor = UIColor.primary100
    static let selectedBorderColor = UIColor.primary500
  }

  private enum Typo {
    static let deselectedTitle = UIFont.captionRegular
    static let selectedTitle = UIFont.captionSemiBold
  }


  // MARK: UI

  private let titleLabel = UILabel()

  private let iconDown = UIImageView().then {
    $0.image = DesignSystemAsset.iconChevronDown.image.withTintColor(.gray500)
  }


  // MARK: Properties

  var viewModel: ViewModel?


  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
    contentView.layer.borderWidth = 1
    contentView.clipsToBounds = true
    contentView.backgroundColor = .clear
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func prepareForReuse() {}


  // MARK: Configuring

  func configure(viewModel: ViewModel) {
    self.viewModel = viewModel

    titleLabel.attributedText = viewModel.title.styled(
      font: viewModel.isFiltered ? Typo.selectedTitle : Typo.deselectedTitle,
      color: viewModel.isFiltered ? .primary500 : .staticBlack
    )

    contentView.backgroundColor = viewModel.isFiltered ? .primary100 : .clear
  }


  // MARK: Layout

  private func defineLayout() {
    [titleLabel, iconDown].forEach { contentView.addSubview($0) }

    titleLabel.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(4.0)
      $0.left.equalToSuperview().inset(8.0)
    }

    iconDown.snp.makeConstraints {
      $0.left.equalTo(titleLabel.snp.right).offset(2.0)
      $0.centerY.equalTo(titleLabel)
      $0.right.equalToSuperview().inset(8.0)
      $0.size.equalTo(16.0)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    contentView.layer.cornerRadius = contentView.frame.height / 2

    contentView.layer.borderColor = viewModel?.isFiltered == true
      ? Color.selectedBorderColor.cgColor
      : Color.deselectedBorderColor.cgColor
  }
}
