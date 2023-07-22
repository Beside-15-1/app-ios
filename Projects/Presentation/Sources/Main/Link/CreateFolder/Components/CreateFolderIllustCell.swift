//
//  CreateFolderIllustCell.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/22.
//

import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem

final class CreateFolderIllustCell: UICollectionViewCell {

  static let identifier = "CreateFolderIllustCell"

  // MARK: UI

  private let noImageLabel = UILabel().then {
    $0.attributedText = "선택 안함".styled(font: .bodyRegular, color: .gray600)
  }

  private let illust = UIImageView()


  // MARK: Properties

  override var isSelected: Bool {
    didSet {
      contentView.backgroundColor = isSelected ? .primary500.withAlphaComponent(0.2) : .gray300
    }
  }


  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.backgroundColor = .gray300
    contentView.layer.cornerRadius = 8
    contentView.clipsToBounds = true

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func prepareForReuse() {
    noImageLabel.isHidden = true
    illust.image = nil
  }


  // MARK: Configuring

  func configure(number: Int) {
    guard number > 0 else {
      noImageLabel.isHidden = false
      illust.image = nil
      return 
    }

    noImageLabel.isHidden = true
    illust.image = UIImage(
      named: "illust\(number)",
      in: DesignSystemResources.bundle,
      compatibleWith: nil
    )
  }


  // MARK: Layout

  private func defineLayout() {
    [noImageLabel, illust].forEach { contentView.addSubview($0) }

    noImageLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }

    illust.snp.makeConstraints {
      $0.size.equalTo(72.0)
      $0.center.equalToSuperview()
    }
  }
}

