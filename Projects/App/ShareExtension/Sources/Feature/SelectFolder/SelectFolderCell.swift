//
//  SelectFolderCell.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/04.
//

import Foundation
import UIKit

import SnapKit
import Then

import Domain
import DesignSystem

class SelectFolderCell: UICollectionViewCell {

  static let identifier = "SelectFolderCell"

  // MARK: UI

  private let titleLabel = UILabel().then {
    $0.font = .defaultSemiBold
    $0.textColor = .staticBlack
  }


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.clipsToBounds = true
    contentView.layer.cornerRadius = 8.0

    defineLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  func configure(with folder: Folder, isSelected: Bool) {
    titleLabel.text = folder.title

    if isSelected {
      contentView.backgroundColor = .gray100
    } else {
      contentView.backgroundColor = .clear
    }
  }


  // MARK: Layout

  private func defineLayout() {
    contentView.addSubview(titleLabel)

    titleLabel.snp.makeConstraints {
      $0.left.equalToSuperview().inset(24.0)
      $0.centerY.equalToSuperview()
    }
  }
}
