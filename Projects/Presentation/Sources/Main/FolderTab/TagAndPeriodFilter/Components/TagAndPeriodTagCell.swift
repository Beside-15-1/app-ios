//
//  TagAndPeriodTagCell.swift
//  Presentation
//
//  Created by 박천송 on 12/21/23.
//

import Foundation
import UIKit

import DesignSystem

class TagAndPeriodTagCell: UITableViewCell {

  static let identifier = "TagAndPeriodTagCell"

  struct ViewModel: Hashable {
    let tag: String
    let isSelected: Bool
  }

  // MARK: UI

  private let titleLabel = UILabel()

  private let checkIcon = UIImageView().then {
    $0.image = DesignSystemAsset.iconCheck.image.withTintColor(.primary500)
  }


  // MARK: Initialize

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    contentView.backgroundColor = .paperWhite
    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }


  // MARK: Configuring

  func configure(viewModel: ViewModel) {
    if viewModel.isSelected {
      titleLabel.attributedText = viewModel.tag.styled(font: .bodyBold, color: .staticBlack)
      checkIcon.isHidden = false
    } else {
      titleLabel.attributedText = viewModel.tag.styled(font: .bodyRegular, color: .staticBlack)
      checkIcon.isHidden = true
    }
  }

  func configureSelected(isSelected: Bool) {
    if isSelected {
      titleLabel.attributedText = titleLabel.text?.styled(font: .bodyBold, color: .staticBlack)
      checkIcon.isHidden = false
    } else {
      titleLabel.attributedText = titleLabel.text?.styled(font: .bodyRegular, color: .staticBlack)
      checkIcon.isHidden = true
    }
  }
  
  override func prepareForReuse() {
    checkIcon.isHidden = true
  }


  // MARK: Layout

  private func defineLayout() {
    contentView.addSubview(titleLabel)
    contentView.addSubview(checkIcon)

    titleLabel.snp.makeConstraints {
      $0.left.equalToSuperview()
      $0.top.bottom.equalToSuperview().inset(12.0)
    }

    checkIcon.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.size.equalTo(24.0)
      $0.right.equalToSuperview()
    }
  }
}
