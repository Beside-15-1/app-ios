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

  private let titleLabel = UILabel()

  private let leftButtonStackView = UIStackView().then {
    $0.spacing = 12.0
    $0.axis = .horizontal
    $0.distribution = .fill
  }

  public let masterDetailButton = UIButton().then {
    $0.setImage(DesignSystemAsset.iconHamburger.image.withTintColor(.white), for: .normal)
  }.then {
    $0.isHidden = true
  }

  // MARK: Initialize

  public init(style: MainNavigationBarStyle) {
    super.init(frame: .zero)

    backgroundColor = .paperAboveBg

    configureTitle(style: style)
    defineLayout(style: style)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }


  // MARK: Configuring

  private func configureTitle(style: MainNavigationBarStyle) {
    switch style {
    case .home:
      titleLabel.attributedText = "Joosum".styled(font: .logo, color: .white)
    case .folder:
      titleLabel.attributedText = "내 폴더".styled(font: .titleBold, color: .white)
    case .mypage:
      titleLabel.attributedText = "내 정보".styled(font: .titleBold, color: .white)
    }
  }


  // MARK: Layout

  private func defineLayout(style: MainNavigationBarStyle) {
    snp.makeConstraints {
      $0.height.equalTo(44.0)
    }

    switch style {
    case .home, .folder, .mypage:
      if UIDevice.current.userInterfaceIdiom == .pad {
        [leftButtonStackView, titleLabel].forEach { addSubview($0) }
        [masterDetailButton].forEach { leftButtonStackView.addArrangedSubview($0) }

        titleLabel.snp.makeConstraints {
          $0.center.equalToSuperview()
        }

        leftButtonStackView.snp.makeConstraints {
          $0.left.equalToSuperview().inset(20.0)
          $0.centerY.equalToSuperview()
        }

      } else {
        [leftButtonStackView].forEach { addSubview($0) }
        [titleLabel].forEach { leftButtonStackView.addArrangedSubview($0) }

        leftButtonStackView.snp.makeConstraints {
          $0.left.equalToSuperview().inset(20.0)
          $0.centerY.equalToSuperview()
        }
      }
    }
  }
}
