//
//  MainNavigationBar.swift
//  DesignSystem
//
//  Created by 박천송 on 2023/08/28.
//

import Foundation
import UIKit

import SnapKit
import Then


public enum MainNavigationBarStyle {
  case home
  case folder
  case mypage
}

public class MainNavigationBar: UIView {

  private let logo = UILabel().then {
    $0.attributedText = "JOOSUM".styled(font: .logo, color: .white)
  }

  private let leftButtonStackView = UIStackView().then {
    $0.spacing = 12.0
    $0.axis = .horizontal
    $0.distribution = .fill
  }

  public let masterDetailButton = UIButton().then {
    $0.setImage(DesignSystemAsset.iconMasterDetail.image.withTintColor(.white), for: .normal)
  }.then {
    $0.isHidden = true
  }

  // MARK: Initialize

  public init(style: MainNavigationBarStyle) {
    super.init(frame: .zero)

    backgroundColor = .paperAboveBg

    defineLayout(style: style)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }


  // MARK: Layout

  private func defineLayout(style: MainNavigationBarStyle) {
    snp.makeConstraints {
      $0.height.equalTo(44.0)
    }

    switch style {
    case .home, .folder, .mypage:
      if UIDevice.current.userInterfaceIdiom == .pad {
        [leftButtonStackView, logo].forEach { addSubview($0) }
        [masterDetailButton].forEach { leftButtonStackView.addArrangedSubview($0) }

        logo.snp.makeConstraints {
          $0.center.equalToSuperview()
        }

        leftButtonStackView.snp.makeConstraints {
          $0.left.equalToSuperview().inset(20.0)
          $0.centerY.equalToSuperview()
        }

      } else {
        [leftButtonStackView].forEach { addSubview($0) }
        [logo].forEach { leftButtonStackView.addArrangedSubview($0) }

        leftButtonStackView.snp.makeConstraints {
          $0.left.equalToSuperview().inset(20.0)
          $0.centerY.equalToSuperview()
        }
      }
    }
  }
}
