//
//  PeriodInputView.swift
//  Presentation
//
//  Created by 박천송 on 1/10/24.
//

import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem

class PeriodInputView: UIView {

  // MARK: UI

  private let startInputField = PeriodInputField()

  private let endInputField = PeriodInputField()

  private let wave = UILabel().then {
    $0.attributedText = "~".styled(font: .defaultRegular, color: .gray900)
  }


  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
    setDate()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  private func setDate() {
    endInputField.configureDate(date: Date())
    startInputField.configureDate(date: Date(timeIntervalSinceNow: -3600 * 24 * 30))
  }


  // MARK: Layout

  private func defineLayout() {
    [startInputField, wave, endInputField].forEach {
      addSubview($0)
    }

    wave.snp.makeConstraints {
      $0.center.equalToSuperview()
    }

    startInputField.snp.makeConstraints {
      $0.left.top.bottom.equalToSuperview()
      $0.right.equalTo(wave.snp.left).offset(-4)
      $0.height.equalTo(40.0)
    }

    endInputField.snp.makeConstraints {
      $0.right.top.bottom.equalToSuperview()
      $0.left.equalTo(wave.snp.right).offset(4)
      $0.height.equalTo(40.0)
    }
  }
}
