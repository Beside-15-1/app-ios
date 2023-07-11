//
//  HomeLinkCell.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/06.
//

import Foundation
import UIKit

import SnapKit
import Then
import SDWebImage

import DesignSystem
import Domain

class HomeLinkCell: UICollectionViewCell {

  static let identifier = "HomeLinkCell"

  struct ViewModel: Hashable {
    let id: String
    let imageURL: String?
    let title: String?
    let tag: String?
    let date: String
    let isMore: Bool
  }

  // MARK: UI

  let imageView = UIImageView().then {
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
    $0.image = UIImage().withTintColor(.gray300)
  }

  let titleLabel = UILabel().then {
    $0.numberOfLines = 2
  }

  let tagLabel = UILabel()

  let dateLabel = UILabel()

  let moreView = UIView().then {
    $0.backgroundColor = .paperCard
    $0.isHidden = true
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
  }

  let moreTextButton = TextButton(type: .regular, color: .gray700).then {
    $0.text = "더보기"
    $0.leftIconImage = DesignSystemAsset.iconPlus.image
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

    moreView.isHidden = true
  }


  // MARK: Configuring

  func configure(viewModel: ViewModel) {
    guard !viewModel.isMore else {
      moreView.isHidden = false
      return
    }

    if let imageURL = viewModel.imageURL {
      imageView.sd_setImage(with: URL(string: imageURL))
    } else {
      imageView.image = DesignSystemAsset.homeLinkEmptyImage.image
    }

    if let title = viewModel.title {
      titleLabel.attributedText = title.styled(font: .subTitleSemiBold, color: .staticBlack)
    } else {
      titleLabel.attributedText = "제목 없음".styled(font: .subTitleSemiBold, color: .staticBlack)
    }

    if let tag = viewModel.tag {
      tagLabel.attributedText = tag.styled(font: .bodyRegular, color: .gray800)
    }

    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    let date = dateFormatter.date(from: viewModel.date)
    dateFormatter.dateFormat = "yyyy년 MM월 dd일"

    let stringFromDate = dateFormatter.string(from: date ?? Date())

    dateLabel.attributedText = "\(stringFromDate) 주섬주섬".styled(font: .captionRegular, color: .gray500)
  }


  // MARK: Layout

  private func setContentView() {
    // 코너 반경 설정
    contentView.layer.cornerRadius = 8

    // 그림자 설정
    contentView.layer.shadowColor = UIColor.black.cgColor
    contentView.layer.shadowOpacity = 0.1
    contentView.layer.shadowOffset = CGSize(width: 0, height: 4)
    contentView.layer.shadowRadius = 2

    // 그림자 경로 설정 (코너 반경을 고려)
    contentView.layer.shadowPath = UIBezierPath(
      roundedRect: contentView.bounds,
      cornerRadius: contentView.layer.cornerRadius
    ).cgPath

    // 그림자를 보여주기 위해 배경색 설정 (선택 사항)
    contentView.backgroundColor = .paperCard
  }

  private func defineLayout() {
    [imageView, titleLabel, tagLabel, dateLabel, moreView].forEach { contentView.addSubview($0) }
    moreView.addSubview(moreTextButton)

    imageView.snp.makeConstraints {
      $0.top.equalToSuperview().inset(16.0)
      $0.left.right.equalToSuperview().inset(20.0)
      $0.height.equalTo(92.0)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(8.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    dateLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(16.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    tagLabel.snp.makeConstraints {
      $0.bottom.equalTo(dateLabel.snp.top)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    moreView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    moreTextButton.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }

  override func layoutSubviews() {
    setContentView()
  }
}
