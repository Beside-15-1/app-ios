//
//  SelectPeriodView.swift
//  Presentation
//
//  Created by 박천송 on 12/20/23.
//

import UIKit

import SnapKit
import Then

import DesignSystem
import Domain
import PresentationInterface

protocol SelectPeriodViewDelegate: AnyObject {
  func selectPeriodViewButtonTapped(type: PeriodType)
}

final class SelectPeriodView: UIView {

  // MARK: UI

  private let titleLabel = UILabel().then {
    $0.attributedText = "링크를 저장한 기간".styled(font: .subTitleSemiBold, color: .gray900)
  }

  private let stackView = UIStackView().then {
    $0.axis = .horizontal
    $0.distribution = .fillEqually
    $0.layer.cornerRadius = 8
    $0.layer.borderColor = UIColor.gray400.cgColor
    $0.layer.borderWidth = 1
    $0.layer.masksToBounds = true
    $0.spacing = 1
    $0.backgroundColor = .gray400
  }

  private var periodButtons: [PeriodButton] = []


  // MARK: Properties

  weak var delegate: SelectPeriodViewDelegate?


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.backgroundColor = .paperWhite

    defineLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Layout

  private func defineLayout() {
    [titleLabel, stackView].forEach {
      addSubview($0)
    }

    titleLabel.snp.makeConstraints {
      $0.top.left.equalToSuperview()
    }

    stackView.snp.makeConstraints {
      $0.left.right.bottom.equalToSuperview()
      $0.top.equalTo(titleLabel.snp.bottom).offset(12.0)
      $0.height.equalTo(32.0)
    }

    PeriodType.allCases.forEach { type in
      let button = PeriodButton().then {
        $0.configure(type: type)
      }

      button.addAction(UIAction(handler: { [weak self] _ in
        self?.delegate?.selectPeriodViewButtonTapped(type: type)
        self?.configurePeriodButton(type: type)
      }), for: .touchUpInside)

      stackView.addArrangedSubview(button)

      periodButtons.append(button)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }


  func configurePeriodButton(type: PeriodType) {
    periodButtons.forEach { button in
      button.isSelected = button.title == type.rawValue
    }
  }
}
