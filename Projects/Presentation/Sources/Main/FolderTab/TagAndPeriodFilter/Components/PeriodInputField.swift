//
//  PeriodInputField.swift
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

class PeriodInputField: UIControl {

  // MARK: UI

  lazy var textField = UITextField().then {
    $0.inputView = datePicker
    $0.clearButtonMode = .never
    $0.tintColor = .clear
  }

  private let datePicker = UIDatePicker().then {
    $0.datePickerMode = .date
    $0.preferredDatePickerStyle = .inline
    $0.locale = Locale(identifier: "ko-KR")
  }

  var currentDate = Date()

  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .gray200
    layer.cornerRadius = 8
    clipsToBounds = true

    defineLayout()

    datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }


  // MARK: Override

  @discardableResult
  override func becomeFirstResponder() -> Bool {
    textField.becomeFirstResponder()
  }

  @discardableResult
  override func resignFirstResponder() -> Bool {
    textField.resignFirstResponder()
  }


  // MARK: Configuring

  func configureDate(date: Date) {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy.MM.dd"

    textField.attributedText = dateFormatter.string(from: date).styled(
      font: .defaultRegular,
      color: .gray900
    )
  }

  func configureMaximumDate(date: Date) {
    datePicker.maximumDate = date
  }

  func configureMinimumDate(date: Date) {
    datePicker.minimumDate = date
  }

  @objc
  func dateChanged() {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy.MM.dd"

    // 선택된 날짜를 TextField에 표시
    textField.attributedText = dateFormatter.string(from: datePicker.date).styled(
      font: .defaultRegular, 
      color: .gray900
    )

    // DatePicker를 숨김
    textField.resignFirstResponder()
  }

  @objc
  func cancelButtonTapped() {
    // DatePicker를 숨김
    textField.resignFirstResponder()
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(textField)
    textField.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(12.0)
      $0.top.bottom.equalToSuperview().inset(8.0)
    }
  }
}


// MARK: Rx

extension Reactive where Base: PeriodInputField {
  var text: ControlProperty<String?> {
    base.textField.rx.text
  }
}
