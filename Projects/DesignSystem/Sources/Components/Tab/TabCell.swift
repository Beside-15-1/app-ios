//
//  TabCell.swift
//  DesignSystem
//
//  Created by 박천송 on 2023/06/12.
//

import Foundation
import UIKit

class TabCell: UICollectionViewCell {

  static let identifier = "TabCell"

  // MARK: UI

  private let container = UIView()

  private let titleLabel = UILabel().then {
    $0.font = .subTitleRegular
    $0.textColor = .gray600
    $0.textAlignment = .center
  }

  private let underBar = UIView().then {
    $0.backgroundColor = .primary500
    $0.isHidden = true
  }


  // MARK: Properties

  override var isSelected: Bool {
    didSet {
      guard isSelected != oldValue else { return }
      configure(isSelected: isSelected)
    }
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

  func configureTitle(title: String) {
    titleLabel.text = title
  }

  func configure(isSelected: Bool) {
    if isSelected {
      underBar.isHidden = false
      titleLabel.textColor = .primary500
      titleLabel.font = .subTitleBold
    } else {
      underBar.isHidden = true
      titleLabel.textColor = .gray600
      titleLabel.font = .subTitleRegular
    }
  }


  // MARK: Layout

  private func defineLayout() {
    contentView.addSubview(container)
    [titleLabel, underBar].forEach { container.addSubview($0) }

    container.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.height.equalTo(40.0)
    }

    titleLabel.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.top.equalToSuperview().inset(4.0)
      $0.width.greaterThanOrEqualTo(68.0)
    }

    underBar.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.bottom.equalToSuperview().inset(4.0)
      $0.height.equalTo(2.0)
    }
  }
}
