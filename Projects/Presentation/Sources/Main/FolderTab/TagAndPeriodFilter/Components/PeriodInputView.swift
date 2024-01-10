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

class PeriodInputView: UIView {

  // MARK: UI

  private let startInputField = PeriodInputField()

  private let endInputField = PeriodInputField()

  private let wave = UILabel().then {
    $0.attributedText = "~".styled(font: .defaultRegular, color: .gray900)
  }


  // MARK: Properties

  private var startDate = Date(timeIntervalSinceNow: -3600 * 24 * 30)
  private var endDate = Date()

  private let disposeBag = DisposeBag()


  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
    setDate()
    addTarget()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  private func setDate() {
    startInputField.configureDate(date: startDate)
    endInputField.configureDate(date: endDate)

    startInputField.configureMaximumDate(date: endDate)
    endInputField.configureMinimumDate(date: startDate)
    endInputField.configureMaximumDate(date: Date())
  }


  // MARK: Target

  private func addTarget() {
    startInputField.rx.text.orEmpty
      .subscribe(onNext: { [weak self] text in
        guard let self else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        guard let date = dateFormatter.date(from: text) else {
          return
        }

        startDate = date

        setDate()
      })
      .disposed(by: disposeBag)

    endInputField.rx.text.orEmpty
      .subscribe(onNext: { [weak self] text in
        guard let self else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        guard let date = dateFormatter.date(from: text) else {
          return
        }

        endDate = date

        setDate()
      })
      .disposed(by: disposeBag)
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
