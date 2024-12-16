//
//  CreateLinkSuccessView.swift
//  ShareExtension
//
//  Created by 박천송 on 2023/08/21.
//

import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem

class CreateLinkSuccessView: UIView {

  // MARK: UI

  let titleLabel = UILabel().then {
    $0.attributedText = "링크가 정상적으로 저장되었어요!".styled(font: .defaultSemiBold, color: .black)
  }

  let subtitleLabel = UILabel().then {
    $0.attributedText = "제목이나 폴더를 수정해서 저장해보세요.".styled(font: .bodyRegular, color: .black)
  }

  let iconView = UIView().then {
    $0.backgroundColor = .primary300
    $0.layer.cornerRadius = 32 / 2
    $0.clipsToBounds = true
  }

  let icon = UIImageView().then {
    $0.image = DesignSystemAsset.iconCheckCircleFill.image.withTintColor(.primary500)
  }


  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .primary100
    layer.cornerRadius = 8
    clipsToBounds = true

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }


  // MARK: Configuring

  func configure(status: ShareStatus) {
    switch status {
    case .loading:
      break

    case .success:
      titleLabel.attributedText = "링크가 정상적으로 저장되었어요!".styled(font: .defaultSemiBold, color: .black)
      subtitleLabel.attributedText = "제목이나 폴더를 수정해서 저장해보세요.".styled(font: .bodyRegular, color: .black)
      icon.image = DesignSystemAsset.iconCheck.image.withTintColor(.primary500)

    case .needLogin:
      titleLabel.attributedText = "로그인 후 저장할 수 있어요!".styled(font: .defaultSemiBold, color: .black)
      subtitleLabel.attributedText = "앱으로 접속하여 로그인 후 사용해보세요.".styled(font: .bodyRegular, color: .black)
      icon.image = DesignSystemAsset.iconPersonFill.image.withTintColor(.primary500)

    case .failure:
      titleLabel.attributedText = "네트워크 에러.".styled(font: .defaultSemiBold, color: .black)
      subtitleLabel.attributedText = "연결 확인 후 다시 시도해주세요.".styled(font: .bodyRegular, color: .black)
      icon.image = DesignSystemAsset.iconNetworkError.image.withTintColor(.primary500)
    }
  }


  // MARK: Layout

  private func defineLayout() {
    [iconView, titleLabel, subtitleLabel].forEach {
      addSubview($0)
    }
    iconView.addSubview(icon)

    iconView.snp.makeConstraints {
      $0.left.equalToSuperview().inset(24.0)
      $0.centerY.equalToSuperview()
      $0.size.equalTo(32.0)
    }

    icon.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.size.equalTo(18.0)
    }

    titleLabel.snp.makeConstraints {
      $0.left.equalTo(iconView.snp.right).offset(8.0)
      $0.top.equalToSuperview().inset(16.0)
      $0.right.equalToSuperview().inset(24.0)
    }

    subtitleLabel.snp.makeConstraints {
      $0.left.equalTo(iconView.snp.right).offset(8.0)
      $0.top.equalTo(titleLabel.snp.bottom).offset(4.0)
      $0.bottom.equalToSuperview().inset(16.0)
      $0.right.equalToSuperview().inset(24.0)
    }
  }
}

