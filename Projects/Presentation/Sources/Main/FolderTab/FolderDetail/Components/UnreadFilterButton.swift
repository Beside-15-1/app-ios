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

  private let checkBox = CheckBox(type: .fill).then {
    $0.isUserInteractionEnabled = false
  }

  private let label = UILabel().then {
    $0.attributedText = "읽지 않음".styled(font: .subTitleSemiBold, color: .gray100)
  }


  // MARK: Properties

  override var isSelected: Bool {
    didSet {
      checkBox.isSelected = isSelected
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
      $0.left.centerY.equalToSuperview()
    }

    label.snp.makeConstraints {
      $0.top.bottom.right.equalToSuperview()
      $0.left.equalTo(checkBox.snp.right).offset(8.0)
    }
  }
}
