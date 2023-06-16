import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem

class TagListCell: UITableViewCell {
  static let identifier = "TagListCell"

  override var isSelected: Bool {
    didSet {
      iconCheck.isHidden = !isSelected
      titleLabel.font = isSelected ? .bodyBold : .bodyRegular
    }
  }

  // MARK: UI

  private let iconHamburger = UIImageView().then {
    $0.image = DesignSystemAsset.iconHamburger.image.withTintColor(.gray600)
  }

  private let titleLabel = UILabel().then {
    $0.font = .bodyRegular
    $0.textColor = .staticBlack
  }

  private let iconCheck = UIImageView().then {
    $0.image = DesignSystemAsset.iconCheck.image.withTintColor(.primary500)
  }

  // MARK: Initialize

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  // MARK: Configuring

  func configureText(text: String) {
    titleLabel.text = text
  }

  // MARK: Layout

  private func defineLayout() {
    contentView.addSubview(titleLabel)
    contentView.addSubview(iconHamburger)
    contentView.addSubview(iconCheck)

    iconHamburger.snp.makeConstraints {
      $0.left.equalToSuperview()
      $0.size.equalTo(20.0)
      $0.centerY.equalToSuperview()
    }

    titleLabel.snp.makeConstraints {
      $0.left.equalTo(iconHamburger.snp.right).offset(8.0)
      $0.top.bottom.equalToSuperview().inset(12.0)
    }

    iconCheck.snp.makeConstraints {
      $0.right.equalToSuperview()
      $0.size.equalTo(24.0)
      $0.centerY.equalToSuperview()
    }
  }
}
