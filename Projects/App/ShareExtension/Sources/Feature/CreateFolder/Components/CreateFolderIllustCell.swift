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

  private let container = UIView().then {
    $0.backgroundColor = .illustBg
  }

  private let noImageLabel = UILabel().then {
    $0.attributedText = "선택 안함".styled(font: .bodyRegular, color: .gray700)
  }

  private let illust = UIImageView()


  // MARK: Properties

  override var isSelected: Bool {
    didSet {
      container.backgroundColor = isSelected ? .primary500.withAlphaComponent(0.2) : .illustBg
    }
  }


  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    contentView.backgroundColor = .illustBg
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
    [container].forEach { contentView.addSubview($0) }
    [noImageLabel, illust].forEach { container.addSubview($0) }

    container.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    noImageLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }

    illust.snp.makeConstraints {
      $0.size.equalTo(72.0)
      $0.center.equalToSuperview()
    }
  }
}

