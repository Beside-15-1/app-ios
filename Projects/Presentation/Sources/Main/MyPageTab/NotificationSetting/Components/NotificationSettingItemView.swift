//
//  NotificationSettingItemView.swift
//  Presentation
//
//  Created by 박천송 on 10/24/23.
//

import UIKit

import SnapKit
import Then

import DesignSystem

enum NotificationSettingItemType {
  case unread
  case unclassify
}

final class NotificationSettingItemView: UIView {

  private let titleLabel = UILabel()

  private let descriptionLabel = UILabel()

  let settingSwitch = UISwitch().then {
    $0.onTintColor = .naviBtnActive
    $0.isOn = false
  }

  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .paperWhite

    defineLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  func configure(type: NotificationSettingItemType) {
    switch type {
    case .unread:
      titleLabel.do {
        $0.attributedText = "읽지 않은 링크".styled(font: .subTitleSemiBold, color: .staticBlack)
      }

      descriptionLabel.do {
        $0.attributedText = "‘읽지 않음' 상태의 링크 알림".styled(font: .bodyRegular, color: .gray700)
      }

    case .unclassify:
      titleLabel.do {
        $0.attributedText = "분류되지 않은 링크".styled(font: .subTitleSemiBold, color: .staticBlack)
      }

      descriptionLabel.do {
        $0.attributedText = "‘기본' 폴더에 분류된 링크 알림".styled(font: .bodyRegular, color: .gray700)
      }
    }
  }

  func configureSwitch(isOn: Bool) {
    settingSwitch.isOn = isOn
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(titleLabel)
    addSubview(descriptionLabel)
    addSubview(settingSwitch)

    self.snp.makeConstraints {
      $0.height.equalTo(92.0)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(20.0)
      $0.left.equalToSuperview()
    }

    descriptionLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(20.0)
      $0.left.equalToSuperview()
    }

    settingSwitch.snp.makeConstraints {
      $0.right.centerY.equalToSuperview()
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
