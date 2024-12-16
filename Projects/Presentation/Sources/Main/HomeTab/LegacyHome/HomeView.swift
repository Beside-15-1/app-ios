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
    $0.backgroundColor = .paperAboveBg
  }

  let navigationBar = MainNavigationBar(style: .home)

  private let titleLabel = UILabel().then {
    $0.attributedText = "최근 주섬주섬 했던\n링크를 확인해보세요"
      .styled(font: .titleBold, color: .white)
    $0.numberOfLines = 0
  }

  let viewAllButton = TextButton(type: .regular, color: .white).then {
    $0.text = "전체보기"
    $0.rightIconImage = DesignSystemAsset.iconChevronRight.image
  }

  let homeLinkView = HomeLinkView()

  let homeFolderView = HomeFolderView()

  private let safeArea = UIView().then {
    $0.backgroundColor = .paperAboveBg
  }

  let fab = FAB().then {
    $0.expand()
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


  // MARK: Configuring

  func applyCollectionViewDataSource(by sectionViewModel: HomeLinkSectionViewModel) {
    homeLinkView.applyCollectionViewDataSource(by: sectionViewModel)
  }

  func configureTitleWithUnreadLinkCount(linkCount: Int, unreadLinkCount: Int) {
    if linkCount == 0 {
      titleLabel.do {
        $0.attributedText = "저장된 링크가 없어요\n새로운 링크를 저장해보세요"
          .styled(font: .titleBold, color: .white)
        $0.numberOfLines = 0
      }
    }

    if unreadLinkCount > 0 {
      titleLabel.do {
        $0.attributedText = "읽지 않은 링크가\n\(unreadLinkCount)개 있어요."
          .styled(font: .titleBold, color: .white)
        $0.numberOfLines = 0
      }
    }

    if unreadLinkCount == 0 {
      titleLabel.do {
        $0.attributedText = "최근 주섬주섬 했던\n링크를 확인해보세요"
          .styled(font: .titleBold, color: .white)
        $0.numberOfLines = 0
      }
    }
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(colorBackground)
    [navigationBar, titleLabel, viewAllButton, homeLinkView, homeFolderView].forEach { addSubview($0) }
    addSubview(fab)

    colorBackground.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
      $0.height.equalTo(349.0)
    }

    navigationBar.snp.makeConstraints {
      $0.left.right.top.equalTo(safeAreaLayoutGuide)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(navigationBar.snp.bottom).offset(14.0)
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
    }

    fab.snp.makeConstraints {
      $0.right.equalToSuperview().inset(20.0)
      $0.bottom.equalTo(safeAreaLayoutGuide).inset(12.0)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
