//
//  FolderDetailCell.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/17.
//

import Foundation
import UIKit

import RxSwift
import SnapKit
import Then

import DesignSystem

class FolderDetailCell: UICollectionViewCell {

  static let identifier = "FolderDetailCell"

  struct ViewModel: Hashable {
    let id: String
    let title: String
    let tags: [String]
    let thumbnailURL: String?
    let url: String
    let createAt: String
    let folderName: String
    let isAll: Bool
  }

  // MARK: UI

  private let titleLabel = UILabel()

  private let thumbnail = UIImageView().then {
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
    $0.contentMode = .scaleAspectFill
    $0.image = DesignSystemAsset.homeLinkEmptyImage.image
  }

  private let tagLabel = UILabel()

  private let captionLabel = UILabel()

  let moreButton = UIButton().then {
    $0.setImage(DesignSystemAsset.iconMoreVertical.image.withTintColor(.gray500), for: .normal)
  }

  let underLine = UIView().then {
    $0.backgroundColor = .gray300
  }

  // MARK: Properties

  var disposeBag = DisposeBag()


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
  }


  // MARK: Configuring

  func configure(viewModel: ViewModel) {
    titleLabel.do {
      $0.attributedText = viewModel.title.styled(font: .subTitleBold, color: .staticBlack)
    }

    tagLabel.do {
      let tagText = viewModel.tags.reduce("") { $0 + "#\($1) " }
      $0.attributedText = tagText.styled(font: .bodyRegular, color: .gray800)
    }

    captionLabel.do {

      // URL
      let prefixes = ["https://", "http://"]
      var caption = viewModel.url

      for prefix in prefixes {
        if caption.hasPrefix(prefix) {
          caption = String(caption.dropFirst(prefix.count))
        }
      }

      // Date
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

      let date = dateFormatter.date(from: viewModel.createAt)
      dateFormatter.dateFormat = "yy.MM.dd"

      let stringFromDate = dateFormatter.string(from: date ?? Date())

      caption += " | \(stringFromDate)"

      // Folder
      if viewModel.isAll {
        caption += " | \(viewModel.folderName) "
      }

      $0.attributedText = caption.styled(font: .captionRegular, color: .gray700)
    }

    if let thumbnailURL = viewModel.thumbnailURL, !thumbnailURL.isEmpty {
      thumbnail.sd_setImage(with: URL(string: thumbnailURL), placeholderImage: UIImage().withTintColor(.gray300))
    } else {
      thumbnail.image = DesignSystemAsset.homeLinkEmptyImage.image
    }

  }


  // MARK: Layout

  private func defineLayout() {
    [titleLabel, thumbnail, tagLabel, captionLabel, moreButton, underLine].forEach {
      contentView.addSubview($0)
    }

    thumbnail.snp.makeConstraints {
      $0.size.equalTo(84)
      $0.left.equalToSuperview()
      $0.top.bottom.equalToSuperview().inset(20.0)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().inset(20.0)
      $0.left.equalTo(thumbnail.snp.right).offset(12.0)
      $0.right.equalToSuperview()
    }

    tagLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom)
      $0.left.equalTo(thumbnail.snp.right).offset(12.0)
      $0.right.equalToSuperview()
    }

    captionLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(20.0)
      $0.left.equalTo(thumbnail.snp.right).offset(12.0)
    }

    moreButton.snp.makeConstraints {
      $0.size.equalTo(24.0)
      $0.right.equalToSuperview()
      $0.bottom.equalToSuperview().inset(20.0)
      $0.left.equalTo(moreButton.snp.right)
    }

    underLine.snp.makeConstraints {
      $0.left.right.bottom.equalToSuperview()
      $0.height.equalTo(1.0)
    }
  }
}
