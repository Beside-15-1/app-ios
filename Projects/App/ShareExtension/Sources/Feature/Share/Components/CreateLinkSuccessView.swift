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
    $0.attributedText = "링크가 정상적으로 저장되었어요!".styled(font: .defaultSemiBold, color: .staticBlack)
  }

  let subtitleLabel = UILabel().then {
    $0.attributedText = "제목이나 폴더를 수정해서 저장해보세요.".styled(font: .bodyRegular, color: .staticBlack)
  }

  let checkIcon = UIImageView().then {
    $0.image = DesignSystemAsset.iconCheckFill.image.withTintColor(.primary400)
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


  // MARK: Layout

  private func defineLayout() {
    [checkIcon, titleLabel, subtitleLabel].forEach {
      addSubview($0)
    }

    checkIcon.snp.makeConstraints {
      $0.left.equalToSuperview().inset(24.0)
      $0.centerY.equalToSuperview()
      $0.size.equalTo(40.0)
    }

    titleLabel.snp.makeConstraints {
      $0.left.equalTo(checkIcon.snp.right).offset(8.0)
      $0.top.equalToSuperview().inset(16.0)
      $0.right.equalToSuperview().inset(24.0)
    }

    subtitleLabel.snp.makeConstraints {
      $0.left.equalTo(checkIcon.snp.right).offset(8.0)
      $0.top.equalTo(titleLabel.snp.bottom).offset(4.0)
      $0.bottom.equalToSuperview().inset(16.0)
      $0.right.equalToSuperview().inset(24.0)
    }
  }
}

