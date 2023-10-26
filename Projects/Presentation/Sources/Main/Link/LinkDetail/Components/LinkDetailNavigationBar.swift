//
//  LinkDetailNavigationBar.swift
//  Presentation
//
//  Created by 박천송 on 10/26/23.
//

import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem

final class LinkDetailNavigationBar: UIView {

  // MARK: Constants

  private enum Metric {
    static let height: CGFloat = 62.0
    static let iconSize = CGSize(width: 24.0, height: 24.0)
  }


  // MARK: UI

  private let closeButton = UIButton().then {
    $0.setImage(DesignSystemAsset.iconCloseOutline.image.withTintColor(.staticBlack), for: .normal)
  }

  let shareButton = UIButton().then {
    $0.setImage(DesignSystemAsset.iconShareOutline.image.withTintColor(.staticBlack), for: .normal)
  }

  private let titleLabel = UILabel().then {
    $0.attributedText = "링크 상세정보".styled(font: .titleBold, color: .staticBlack)
  }


  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .staticWhite

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }


  // MARK: Configuring

  func configureCloseButtonAction(action: @escaping ()->Void) {
    closeButton.addAction(UIAction(handler: { _ in
      action()
    }), for: .touchUpInside)
  }

  func configureShareButtonAction(action: @escaping ()->Void) {
    shareButton.addAction(UIAction(handler: { _ in
      action()
    }), for: .touchUpInside)
  }


  // MARK: Layout

  private func defineLayout() {
    [closeButton, shareButton, titleLabel].forEach {
      addSubview($0)
    }

    snp.makeConstraints {
      $0.height.equalTo(Metric.height)
    }

    closeButton.snp.makeConstraints {
      $0.size.equalTo(Metric.iconSize)
      $0.left.equalToSuperview().inset(20.0)
      $0.centerY.equalToSuperview()
    }

    shareButton.snp.makeConstraints {
      $0.size.equalTo(Metric.iconSize)
      $0.right.equalToSuperview().inset(20.0)
      $0.centerY.equalToSuperview()
    }

    titleLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
}
