//
//  UnreadFilterButton.swift
//  Presentation
//
//  Created by 박천송 on 2023/09/14.
//

import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem

class UnreadFilterButton: UIControl {

  // MARK: UI

  private let checkBox = RadioButton(type: .outline).then {
    $0.isUserInteractionEnabled = false
  }

  private let label = UILabel().then {
    $0.attributedText = "읽지 않음".styled(font: .subTitleSemiBold, color: .gray500)
  }


  // MARK: Properties

  override var isSelected: Bool {
    didSet {
      checkBox.isSelected = isSelected
      label.do {
        if isSelected {
          $0.attributedText = "읽지 않음".styled(font: .subTitleSemiBold, color: .white)
        } else {
          $0.attributedText = "읽지 않음".styled(font: .subTitleSemiBold, color: .gray500)
        }
      }
    }
  }


  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    addAction()
    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }


  // MARK: Action

  private func addAction() {
    addAction(UIAction(handler: { [weak self] _ in
      self?.isSelected.toggle()
    }), for: .touchUpInside)
  }


  // MARK: Layout

  private func defineLayout() {
    [checkBox, label].forEach { addSubview($0) }

    checkBox.snp.makeConstraints {
      $0.left.top.bottom.equalToSuperview()
      $0.size.equalTo(20.0)
    }

    label.snp.makeConstraints {
      $0.centerY.right.equalToSuperview()
      $0.left.equalTo(checkBox.snp.right).offset(8.0)
    }
  }
}
