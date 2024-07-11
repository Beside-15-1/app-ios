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

class HomeFeedCell: UICollectionViewCell {

  static let identifier = "HomeFeedCell"

  struct ViewModel: Hashable {
    let id: String
    let imageURL: String?
    let linkURL: String?
    let title: String?
    let tagList: [Tag]
    let date: String
  }


  // MARK: UI

  let flexContainer = UIView().then {
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
    $0.backgroundColor = .paperWhite
  }

  let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.clipsToBounds = true
    $0.backgroundColor = .black
    $0.image = DesignSystemAsset.homeFeedDefault.image
  }

  let titleLabel = UILabel().then {
    $0.numberOfLines = 1
  }

  let tagView = HomeFeedTagView()

  let dateLabel = UILabel()


  // MARK: Properties

  var viewModel: ViewModel?


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
    viewModel = nil
    imageView.image = nil
    imageView.sd_cancelCurrentImageLoad()
    titleLabel.text = nil
    dateLabel.text = nil
  }


  // MARK: Configuring

  func configure(viewModel: ViewModel) {
    self.viewModel = viewModel

    titleLabel.numberOfLines = viewModel.tagList.count == 0 ? 2 : 1

    titleLabel.attributedText = viewModel.title?.styled(font: .defaultBold, color: .gray900)

    if let url = viewModel.imageURL {
      imageView.sd_setImage(with: URL(string: url))
    }

    tagView.configureTags(tags: viewModel.tagList)

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    let date = dateFormatter.date(from: viewModel.date)
    dateFormatter.dateFormat = "yyyy년 MM월 dd일"

    let stringFromDate = dateFormatter.string(from: date ?? Date())

    dateLabel.attributedText = "\(stringFromDate) 주섬주섬".styled(font: .captionRegular, color: .gray500)
  }


  // MARK: Layout

  private func defineLayout() {
    contentView.addSubview(flexContainer)
    [
      imageView,
      titleLabel,
      tagView,
      dateLabel,
    ].forEach {
      flexContainer.addSubview($0)
    }

    flexContainer.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
      $0.left.right.equalToSuperview().inset(20.0)
    }

    imageView.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
      $0.width.equalTo(UIScreen.main.bounds.width - 40)
      $0.height.equalTo((UIScreen.main.bounds.width - 40) * 162 / 335)
    }

    titleLabel.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(16.0)
      $0.top.equalTo(imageView.snp.bottom).offset(16.0)
    }

    tagView.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(16.0)
      $0.top.equalTo(titleLabel.snp.bottom).offset(8.0)
    }

    dateLabel.snp.makeConstraints {
      $0.left.right.bottom.equalToSuperview().inset(16.0)
      $0.top.equalTo(tagView.snp.bottom).offset(8.0)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    print("UIScreen.main.bounds.width: \(UIScreen.main.bounds.width - 40)")
    print("width: \(imageView.frame.width) height: \(imageView.frame.height)")
  }

  override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes)
    -> UICollectionViewLayoutAttributes {
    setNeedsLayout()
    layoutIfNeeded()

    let size = contentView.systemLayoutSizeFitting(layoutAttributes.size)
    var frame = layoutAttributes.frame
    frame.size.height = ceil(size.height)
    layoutAttributes.frame = frame

    return layoutAttributes
  }
}
