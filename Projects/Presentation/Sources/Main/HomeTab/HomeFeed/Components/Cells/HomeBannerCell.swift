//
//  HomeFeedFeedCell.swift
//  Presentation
//
//  Created by 박천송 on 6/21/24.
//

import Foundation
import UIKit

import SDWebImage
import SnapKit
import Then

import DesignSystem
import Domain

class HomeBannerCell: UICollectionViewCell {

  static let identifier = "HomeBannerCell"

  struct ViewModel: Hashable {
    let id: String
    let imageURL: String?
  }


  // MARK: UI

  let flexContainer = UIView().then {
    $0.backgroundColor = .paperWhite
  }

  let imageView = UIImageView().then {
    $0.image = DesignSystemAsset.homeFeedDefault.image
  }


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
//    imageView.image = DesignSystemAsset.homeFeedDefault.image
  }


  // MARK: Configuring

  func configure(viewModel: ViewModel) {
    if let url = viewModel.imageURL {
      imageView.sd_setImage(with: URL(string: url))
    }
  }


  // MARK: Layout

  private func defineLayout() {
    contentView.addSubview(flexContainer)
    flexContainer.addSubview(imageView)

    flexContainer.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    imageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
