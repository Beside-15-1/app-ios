//
//  LinkDetailView.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/18.
//

import UIKit

import SnapKit
import Then

import DesignSystem
import Domain

final class LinkDetailView: UIView {

  // MARK: UI

  private let folderTitleContainer = UIView()
  private let folderTitleLabel = UILabel()
  private let folderTitleIcon = UIImageView().then {
    $0.image = DesignSystemAsset.iconFolderOpen.image.withTintColor(.gray600)
  }

  private let thumbnail = UIImageView().then {
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 8
    $0.contentMode = .scaleAspectFit
  }

  private let urlContainer = UIControl()
  private let urlLabel = UILabel()
  private let urlIcon = UIImageView().then {
    $0.image = DesignSystemAsset.logoJoosumSmall.image.withTintColor(.gray600)
  }

  private let linkTitleLabel = UILabel().then {
    $0.numberOfLines = 0
  }

  private let dateLabel = UILabel()

  private let tagView = LinkDetailTagView()

  let bottomView = LinkDetailBottomView()

  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.backgroundColor = .staticWhite

    defineLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  func configure(withLink link: Link) {
    folderTitleLabel.attributedText = link.folderName.styled(font: .captionRegular, color: .gray600)

    if let thumbnailURL = link.thumbnailURL, !thumbnailURL.isEmpty {
      thumbnail.sd_setImage(with: URL(string: thumbnailURL))
    } else {
      thumbnail.image = DesignSystemAsset.homeLinkEmptyImage.image
    }

    urlLabel.attributedText = link.url.styled(font: .captionRegular, color: .gray600)

    linkTitleLabel.attributedText = link.title.styled(font: .subTitleBold, color: .gray900)

    // Date
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    let date = dateFormatter.date(from: link.createdAt)
    dateFormatter.dateFormat = "yy년 MM월 dd일"

    let stringFromDate = dateFormatter.string(from: date ?? Date())

    dateLabel.attributedText = "\(stringFromDate)에 주섬주섬".styled(font: .captionRegular, color: .gray600)

    tagView.applyTag(by: link.tags)
  }

  func configureFolder(withFolder folder: Folder) {
    folderTitleLabel.attributedText = folder.title.styled(font: .captionRegular, color: .gray600)
  }


  // MARK: Layout

  private func defineLayout() {
    [folderTitleContainer, thumbnail, urlContainer, linkTitleLabel, dateLabel, tagView, bottomView].forEach { addSubview($0) }
    [folderTitleIcon, folderTitleLabel].forEach { folderTitleContainer.addSubview($0) }
    [urlIcon, urlLabel].forEach { urlContainer.addSubview($0) }

    folderTitleContainer.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide)
      $0.centerX.equalToSuperview()
    }

    folderTitleIcon.snp.makeConstraints {
      $0.left.top.bottom.equalToSuperview()
      $0.size.equalTo(16.0)
    }

    folderTitleLabel.snp.makeConstraints {
      $0.right.centerY.equalToSuperview()
      $0.left.equalTo(folderTitleIcon.snp.right).offset(4.0)
    }

    thumbnail.snp.makeConstraints {
      $0.top.equalTo(folderTitleLabel.snp.bottom).offset(24.0)
      $0.left.right.equalToSuperview().inset(20.0)
      $0.height.equalTo((UIScreen.main.bounds.width - 40) * 9.0 / 16.0)
    }

    urlContainer.snp.makeConstraints {
      $0.top.equalTo(thumbnail.snp.bottom).offset(8.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    urlIcon.snp.makeConstraints {
      $0.left.bottom.equalToSuperview()
    }

    urlLabel.snp.makeConstraints {
      $0.top.bottom.right.equalToSuperview()
      $0.left.equalTo(urlIcon.snp.right).offset(4.0)
    }

    linkTitleLabel.snp.makeConstraints {
      $0.top.equalTo(urlLabel.snp.bottom).offset(16.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    dateLabel.snp.makeConstraints {
      $0.top.equalTo(linkTitleLabel.snp.bottom).offset(8.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    tagView.snp.makeConstraints {
      $0.top.equalTo(dateLabel.snp.bottom).offset(28.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    bottomView.snp.makeConstraints {
      $0.top.equalTo(tagView.snp.bottom).offset(8.0)
      $0.left.right.equalToSuperview().inset(20.0)
      $0.bottom.equalTo(safeAreaLayoutGuide).inset(40.0)
    }

  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
