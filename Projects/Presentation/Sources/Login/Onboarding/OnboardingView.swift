//
//  OnboardingView.swift
//  Presentation
//
//  Created by 박천송 on 2023/08/07.
//

import UIKit

import SnapKit
import Then

import DesignSystem

final class OnboardingView: UIView {

  private let pageControl = UIPageControl().then {
    $0.numberOfPages = 3
    $0.currentPage = 0
    $0.pageIndicatorTintColor = .gray400
    $0.currentPageIndicatorTintColor = .primary500
    $0.isUserInteractionEnabled = false
  }

  private let titleLabel = UILabel()

  private let onboardingImage = UIImageView()

  private let buttonContainer = UIView().then {
    $0.backgroundColor = .paperWhite
  }

  let button = BasicButton(priority: .primary)

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

  func configure(type: OnboardingType) {
    switch type {
    case .first:
      titleLabel.attributedText = "링크만 붙여넣으면,\n제목은 자동으로 생성해줘요."
        .styled(font: .titleBold, color: .primary600)
      titleLabel.textAlignment = .center
      onboardingImage.image = DesignSystemAsset.imgOnbording1.image
      button.text = "다음"
      pageControl.currentPage = 0

    case .second:
      titleLabel.attributedText = "나만의 폴더를 생성해서 저장하고\n언제든 쉽게 찾아보세요!"
        .styled(font: .titleBold, color: .primary600)
      titleLabel.textAlignment = .center
      onboardingImage.image = DesignSystemAsset.imgOnbording2.image
      button.text = "다음"
      pageControl.currentPage = 1

    case .third:
      titleLabel.attributedText = "태그를 추가해보세요.\n나중에 어떤 내용인지 확인할 수 있어요."
        .styled(font: .titleBold, color: .primary600)
      titleLabel.textAlignment = .center
      onboardingImage.image = DesignSystemAsset.imgOnbording3.image
      button.text = "주섬 시작하기"
      pageControl.currentPage = 2
    }
  }


  // MARK: Layout

  private func defineLayout() {
    [pageControl, titleLabel, onboardingImage, buttonContainer].forEach {
      addSubview($0)
    }

    buttonContainer.addSubview(button)

    pageControl.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide).inset(48.0)
      $0.centerX.equalToSuperview()
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(pageControl.snp.bottom).offset(20.0)
      $0.centerX.equalToSuperview()
    }

    onboardingImage.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(52.0)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(280.0)
      $0.height.equalTo(601.0)
    }

    buttonContainer.snp.makeConstraints {
      $0.left.right.bottom.equalToSuperview()
    }

    button.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(20.0)
      $0.top.equalToSuperview().inset(12.0)
      $0.bottom.equalTo(safeAreaLayoutGuide).inset(20.0)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
