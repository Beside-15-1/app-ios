//
//  PeriodInputView.swift
//  Presentation
//
//  Created by 박천송 on 1/10/24.
//

import Foundation
import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

import DesignSystem
import Domain

protocol PeriodInputViewDelegate: AnyObject {
  func periodInputView(customPeriod: CustomPeriod)
}

class PeriodInputView: UIView {

  // MARK: UI

  private lazy var startInputField = PeriodInputField().then {
    $0.delegate = self
  }

  private lazy var endInputField = PeriodInputField().then {
    $0.delegate = self
  }

  private let wave = UILabel().then {
    $0.attributedText = "~".styled(font: .defaultRegular, color: .gray900)
  }


  // MARK: Properties

  private var startDate = Date(timeIntervalSinceNow: -3600 * 24 * 30)
  private var endDate = Date()

  private let disposeBag = DisposeBag()

  weak var delegate: PeriodInputViewDelegate?


  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
    endInputField.configureMaximumDate(date: Date())
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  private func setDate() {
    startInputField.configureDate(date: startDate)
    endInputField.configureDate(date: endDate)

    startInputField.configureMaximumDate(date: endDate)
    endInputField.configureMinimumDate(date: startDate)
  }

  func configureDate(startDate: Date, endDate: Date) {
    self.startDate = startDate
    self.endDate = endDate
    setDate()
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


// MARK: PeriodInputFieldDelegate

extension PeriodInputView: PeriodInputFieldDelegate {
  func periodInputField(_ periodInputField: PeriodInputField, changedDate date: Date) {
    switch periodInputField {
    case startInputField:
      self.delegate?.periodInputView(
        customPeriod: .init(startDate: date, endDate: self.endDate)
      )

    case endInputField:
      self.delegate?.periodInputView(
        customPeriod: .init(startDate: self.startDate, endDate: date)
      )

    default:
      return
    }
  }
}
