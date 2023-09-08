//
//  MasterTabCellMakeFolderView.swift
//  Presentation
//
//  Created by 박천송 on 2023/09/06.
//

import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem

class MasterTabCellMakeFolderView: UIView {

  // MARK: Constant

  private enum Metric {
    static let plus = CGSize(width: 28.0, height: 28.0)
  }


  // MARK: UI

  private let container = UIView()

  private let plusIcon = UIImageView().then {
    $0.image = DesignSystemAsset.iconPlus.image.withTintColor(.gray600)
  }

  private let titleLabel = UILabel().then {
    $0.attributedText = "폴더 만들기".styled(font: .defaultBold, color: .gray800)
  }


  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()

    backgroundColor = .gray400
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(container)
    [plusIcon, titleLabel].forEach { container.addSubview($0) }

    container.snp.makeConstraints {
      $0.center.equalToSuperview()
    }

    plusIcon.snp.makeConstraints {
      $0.left.top.bottom.equalToSuperview()
      $0.size.equalTo(Metric.plus)
    }

    titleLabel.snp.makeConstraints {
      $0.right.centerY.equalToSuperview()
      $0.left.equalTo(plusIcon.snp.right).offset(4.0)
    }
  }
}


