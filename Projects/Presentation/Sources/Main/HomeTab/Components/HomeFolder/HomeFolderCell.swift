//
//  HomeFolderCell.swift
//  PresentationInterface
//
//  Created by 박천송 on 2023/07/07.
//

import Foundation
import UIKit

import SnapKit
import Then
import SDWebImage

import DesignSystem
import Domain

class HomeFolderCell: UICollectionViewCell {

  static let identifier = "HomeFolderCell"

  struct ViewModel: Hashable {
    let id: String
    let coverColor: String
    let titleColor: String
    let title: String
    let linkCount: Int
    let illust: String?
    let isLast: Bool
  }

  // MARK: UI

  private let folderCover = UIView().then {
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
  }

  private let verticalBar = UIView().then {
    $0.backgroundColor = .black.withAlphaComponent(0.1)
  }

  private let folderTitle = UILabel().then {
    $0.numberOfLines = 2
  }

  private let countContainer = UIView().then {
    $0.backgroundColor = .staticBlack
    $0.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMaxYCorner]
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
  }

  private let countLabel = UILabel()

  private let illust = UIImageView()

  private let addFolderView = UIView().then {
    $0.backgroundColor = .gray200
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
    $0.isHidden = true
  }

  private let addFolderButton = TextButton(type: .regular, color: .gray600).then {
    $0.text = "폴더 만들기"
    $0.leftIconImage = DesignSystemAsset.iconPlus.image
    $0.isUserInteractionEnabled = false
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
    addFolderView.isHidden = true
    folderCover.backgroundColor = .clear
    countContainer.isHidden = false
  }


  // MARK: Configuring

  func configure(viewModel: ViewModel) {
    guard !viewModel.isLast else {
      addFolderView.isHidden = false
      folderCover.backgroundColor = .clear
      countContainer.isHidden = true
      return
    }

    folderCover.backgroundColor = UIColor(hexString: viewModel.coverColor)

    folderTitle.do {
      $0.attributedText = viewModel.title.styled(
        font: .bodyBold,
        color: UIColor(hexString: viewModel.titleColor)
      )
    }

    countLabel.attributedText = "\(viewModel.linkCount)건".styled(
      font: .captionRegular,
      color: .staticWhite
    )

    if let image = viewModel.illust {
      illust.image = UIImage(
        named: image,
        in: DesignSystemResources.bundle,
        compatibleWith: nil
      )
    }
  }


  // MARK: Layout

  private func setFolderCorverView() {
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
  }

  private func defineLayout() {
    [folderCover, illust, folderTitle, verticalBar, countContainer, addFolderView].forEach { contentView.addSubview($0) }
    countContainer.addSubview(countLabel)
    addFolderView.addSubview(addFolderButton)

    folderCover.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    illust.snp.makeConstraints {
      $0.size.equalTo(72.0)
      $0.right.bottom.equalToSuperview().inset(15.0)
    }

    verticalBar.snp.makeConstraints {
      $0.left.equalToSuperview().inset(8.0)
      $0.top.bottom.equalToSuperview()
      $0.width.equalTo(2.0)
    }

    folderTitle.snp.makeConstraints {
      $0.right.equalToSuperview().inset(10.0)
      $0.top.equalToSuperview().inset(16.0)
      $0.left.equalTo(verticalBar.snp.right).offset(8.0)
    }

    countContainer.snp.makeConstraints {
      $0.right.bottom.equalToSuperview()
      $0.width.equalTo(48.0)
      $0.height.equalTo(24.0)
    }

    countLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }

    addFolderView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    addFolderButton.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }

  override func layoutSubviews() {
    setFolderCorverView()
  }
}
