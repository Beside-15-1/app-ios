//
//  PeriodButton.swift
//  Presentation
//
//  Created by 박천송 on 12/21/23.
//

import Foundation
import UIKit

import DesignSystem
import PresentationInterface

final class PeriodButton: UIControl {

  // MARK: UI

  private let titleLabel = UILabel()


  // MARK: Properties

  override var isSelected: Bool {
    didSet {
      if isSelected {
        backgroundColor = .primary600
        titleLabel.attributedText = titleLabel.text?.styled(font: .bodyBold, color: .white)
      } else {
        backgroundColor = .staticWhite
        titleLabel.attributedText = titleLabel.text?.styled(font: .bodyRegular, color: .gray600)
      }
    }
  }

  var title: String {
    titleLabel.text ?? ""
  }


  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .staticWhite

    addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }


  // MARK: Configuring

  func configure(type: PeriodType) {
    titleLabel.attributedText = type.rawValue.styled(font: .bodyRegular, color: .gray600)
  }
}
