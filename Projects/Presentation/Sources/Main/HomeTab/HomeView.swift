//
//  HomeView.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/05.
//

import UIKit

import SnapKit
import Then

import DesignSystem

final class HomeView: UIView {

  // MARK: UI

  private let scrollView = UIScrollView().then {
    $0.showsVerticalScrollIndicator = false
    $0.showsHorizontalScrollIndicator = false
    $0.scrollsToTop = true
    $0.contentInsetAdjustmentBehavior = .never
    $0.bounces = false
    $0.backgroundColor = .staticWhite
  }

  private let container = UIView()

  private let colorBackground = UIView().then {
    $0.backgroundColor = .paperGray
  }

  private let logoImage = UIImageView().then {
    $0.image = DesignSystemAsset.homeLogo.image.withTintColor(.staticBlack)
  }

  private let titleLabel = UILabel().then {
    $0.attributedText = "최근 주섬주섬 했던\n링크를 확인해보세요"
      .styled(font: .accentTitle, color: .staticBlack)
    $0.numberOfLines = 0
  }

  private let viewAllButton = TextButton(type: .regular, color: .primary500).then {
    $0.text = "전체보기"
    $0.rightIconImage = DesignSystemAsset.iconRight.image
  }

  private let homeLinkView = HomeLinkView()

  private let homeFolderView = HomeFolderView()

  private let safeArea = UIView().then {
    $0.backgroundColor = .paperGray
  }


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
    addSubview(safeArea)
    addSubview(scrollView)
    scrollView.addSubview(colorBackground)
    [logoImage, titleLabel, viewAllButton, homeLinkView, homeFolderView].forEach { scrollView.addSubview($0) }

    safeArea.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
      $0.bottom.equalTo(safeAreaLayoutGuide.snp.top)
    }

    scrollView.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.width.equalToSuperview()
      $0.top.bottom.equalTo(safeAreaLayoutGuide)
    }

    colorBackground.snp.makeConstraints {
      $0.top.width.equalToSuperview()
      $0.height.equalTo(349.0)
    }

    logoImage.snp.makeConstraints {
      $0.top.equalToSuperview().inset(10.0)
      $0.left.equalToSuperview().inset(20.0)
      $0.width.equalTo(88.0)
      $0.height.equalTo(24.0)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(logoImage.snp.bottom).offset(34.0)
      $0.left.equalToSuperview().inset(20.0)
    }

    viewAllButton.snp.makeConstraints {
      $0.right.equalToSuperview().inset(20.0)
      $0.bottom.equalTo(titleLabel)
    }

    homeLinkView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(32.0)
      $0.width.equalToSuperview()
      $0.centerX.equalToSuperview()
    }

    homeFolderView.snp.makeConstraints {
      $0.top.equalTo(homeLinkView.snp.bottom).offset(40.0)
      $0.width.equalToSuperview()
      $0.centerX.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
