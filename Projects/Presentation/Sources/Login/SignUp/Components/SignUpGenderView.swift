//
//  SignUpGenderView.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/05.
//

import UIKit

import SnapKit
import Then

import DesignSystem

final class SignUpGenderView: UIView {

  // MARK: UI

  private let titleLabel = UILabel().then {
    $0.text = "성별을 선택해주세요"
    $0.font = .subTitleSemiBold
    $0.textColor = .gray900
  }

  private let stackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 11.5
    $0.distribution = .fillEqually
  }

  private let manButton = UIButton().then {
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
    $0.setTitle("남자", for: .normal)
    $0.backgroundColor = .gray300
    $0.setTitleColor(.gray700, for: .normal)
    $0.titleLabel?.font = .defaultSemiBold
  }

  private let womanButton = UIButton().then {
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
    $0.setTitle("여자", for: .normal)
    $0.backgroundColor = .gray300
    $0.setTitleColor(.gray700, for: .normal)
    $0.titleLabel?.font = .defaultSemiBold
  }

  private let etcButton = UIButton().then {
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
    $0.setTitle("기타", for: .normal)
    $0.backgroundColor = .gray300
    $0.setTitleColor(.gray700, for: .normal)
    $0.titleLabel?.font = .defaultSemiBold
  }

  private lazy var buttons = [manButton, womanButton, etcButton]


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.backgroundColor = .paperWihte

    defineLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  func configureButtons(selectedButton: String) {
    buttons.forEach {
      if $0.titleLabel?.text == selectedButton {
        select(button: $0)
      } else {
        deselect(button: $0)
      }
    }
  }

  private func deselect(button: UIButton) {
    button.backgroundColor = .gray300
    button.setTitleColor(.gray700, for: .normal)
  }

  private func select(button: UIButton) {
    button.backgroundColor = .primary500
    button.setTitleColor(.white, for: .normal)
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(titleLabel)
    addSubview(stackView)

    [manButton, womanButton, etcButton].forEach { stackView.addArrangedSubview($0) }

    titleLabel.snp.makeConstraints {
      $0.left.top.equalToSuperview()
    }

    stackView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(8.0)
      $0.left.right.bottom.equalToSuperview()
      $0.height.equalTo(48.0)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
