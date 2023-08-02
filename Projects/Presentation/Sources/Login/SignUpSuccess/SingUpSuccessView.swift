//
//  SingUpSuccessView.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/25.
//

import UIKit

import SnapKit
import Then

import DesignSystem

final class SingUpSuccessView: UIView {

  // MARK: UI

  private let imageView = UIImageView().then {
    $0.image = DesignSystemAsset.imgJoin.image.withTintColor(.gray900)
  }

  private let titleLabel = UILabel().then {
    $0.attributedText = "가입이 완료되었어요".styled(font: .subTitleSemiBold, color: .gray900)
  }

  let startButton = BasicButton(priority: .primary).then {
    $0.text = "주섬 시작하기"
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


  // MARK: Layout

  private func defineLayout() {
    [imageView, titleLabel, startButton].forEach {
      addSubview($0)
    }

    imageView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(21)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(230)
      $0.height.equalTo(140)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
    }

    startButton.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(20.0)
      $0.bottom.equalTo(safeAreaLayoutGuide).inset(20.0)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
