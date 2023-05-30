//
//  LoginView.swift
//  Presentation
//
//  Created by 박천송 on 2023/04/30.
//

import Foundation
import UIKit

import AuthenticationServices
import FlexLayout
import PinLayout
import SnapKit
import Then

import DesignSystem

// MARK: - LoginView

class LoginView: UIView {
  // MARK: Constants

  private enum Metric {
    static let logo = CGSize(width: 177.0, height: 49.0)
    static let appleLogo = CGSize(width: 18.0, height: 18.0)
    static let googleLogo = CGSize(width: 18.0, height: 18.0)
  }

  // MARK: UI

  private let flexContainer = UIView()

  private let logo = UIImageView().then {
    $0.image = DesignSystemAsset.loginLogo.image
  }

  private let subTitleLabel = UILabel().then {
    $0.attributedText = "링크를 주섬주섬 담아 어쩌구 저쩌구".styled(
      font: .pretendard(.medium, size: 16),
      color: .linen)
  }

  let googleButton = UIControl().then {
    $0.backgroundColor = .white
    $0.layer.cornerRadius = 4
  }

  private let googleIcon = UIImageView().then {
    $0.image = DesignSystemAsset.googleIcon.image
  }

  private let googleLabel = UILabel().then {
    $0.attributedText = "구글 계정으로 로그인".styled(
      font: .systemFont(ofSize: 14, weight: .regular),
      color: .black.withAlphaComponent(0.54))
  }

  let appleButton = UIControl().then {
    $0.backgroundColor = .black
    $0.layer.cornerRadius = 4
  }

  private let appleIcon = UIImageView().then {
    $0.image = DesignSystemAsset.appleIcon.image
  }

  private let appleLabel = UILabel().then {
    $0.attributedText = "Apple로 로그인".styled(
      font: .systemFont(ofSize: 14, weight: .regular),
      color: .white)
  }

  private let termsLabel = UILabel().then {
    $0.attributedText = "가입을 진행할 경우, 아래의 정책에 동의한 것으로 간주됩니다\n서비스이용약관 및 개인정보처리방침"
      .underLine(range: ["서비스이용약관", "개인정보처리방침"])

    $0.textColor = .linen.withAlphaComponent(0.6)
    $0.font = .pretendard(.medium, size: 12)
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }

  // TODO: 가입,로그인 마무리되면 제거 예정
  let testButton = UIButton().then {
    $0.setTitle("MoveToMain", for: .normal)
  }

  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .darkPurple

    defineLayout()

    // TODO: 가입,로그인 마무리되면 제거 예정
    addSubview(testButton)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  // MARK: Layout

  private func defineLayout() {
    addSubview(flexContainer)

    flexContainer.flex
      .paddingHorizontal(20.0)
      .justifyContent(.spaceBetween)
      .grow(1.0)
      .define { flex in

        // Top
        flex.addItem()
          .marginTop(200.0)
          .alignItems(.center)
          .define { flex in
            flex.addItem(logo)
              .size(Metric.logo)

            flex.addItem(subTitleLabel)
              .shrink(1.0)
              .marginTop(12.0)
          }

        // Bottom
        flex.addItem()
          .width(100%)
          .define { flex in
            flex.addItem(appleButton)
              .marginBottom(12.0)
              .height(40.0)
              .justifyContent(.center)
              .alignItems(.center)
              .direction(.row)
              .define { flex in
                flex.addItem(appleIcon)
                  .size(Metric.appleLogo)

                flex.addItem(appleLabel)
                  .marginStart(8.0)
              }

            flex.addItem(googleButton)
              .marginBottom(60.0)
              .height(40.0)
              .justifyContent(.center)
              .alignItems(.center)
              .direction(.row)
              .define { flex in
                flex.addItem(googleIcon)
                  .size(Metric.googleLogo)

                flex.addItem(googleLabel)
                  .marginStart(8.0)
              }

            flex.addItem(termsLabel)
              .alignSelf(.center)
              .marginBottom(60.0)
          }
      }
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    flexContainer.pin.all()
    flexContainer.flex.layout()

    // TODO: 가입,로그인 마무리되면 제거 예정
    testButton.pin.center().sizeToFit()
  }
}
