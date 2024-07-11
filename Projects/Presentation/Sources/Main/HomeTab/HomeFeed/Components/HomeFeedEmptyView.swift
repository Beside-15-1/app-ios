//
//  HomeFeedEmptyView.swift
//  Presentation
//
//  Created by 박천송 on 7/11/24.
//

import UIKit

import SnapKit
import Then

import DesignSystem


final class HomeFeedEmptyView: UIView {

  // MARK: Constants

  private enum String {
    static let recently = "저장된 링크가 없어요.\n링크를 주섬주섬 담아보세요."
    static let noRead = "저장된 링크를 모두 다 읽었어요!"
  }


  // MARK: UI

  private let imageView = UIImageView()

  private let label = UILabel()


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configureEmptyView(tab: HomeFeedTab) {
    switch tab {
    case .noRead:
      imageView.image = DesignSystemAsset.imgNoReadEmpty.image
      label.attributedText = String.noRead.styled(font: .defaultRegular, color: .gray700)
      imageView.snp.updateConstraints {
        $0.size.equalTo(CGSize(width: 116, height: 119))
      }
    case .recentlySaved:
      imageView.image = DesignSystemAsset.imgRecentlyEmpty.image
      label.attributedText = String.recently.styled(font: .defaultRegular, color: .gray700)
      imageView.snp.updateConstraints {
        $0.size.equalTo(CGSize(width: 157, height: 118))
      }
    }
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(imageView)
    addSubview(label)

    imageView.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.size.equalTo(CGSize(width: 0, height: 0))
    }

    label.snp.makeConstraints {
      $0.centerX.equalTo(imageView)
      $0.top.equalTo(imageView.snp.bottom).offset(12.0)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
