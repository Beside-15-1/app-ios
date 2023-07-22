//
//  MyFolderCell.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/14.
//

import Foundation
import UIKit

import SDWebImage
import SnapKit
import Then
import RxSwift

import DesignSystem
import Domain

class MyFolderCell: UICollectionViewCell {

  static let identifier = "MyFolderCell"

  struct ViewModel: Hashable {
    let id: String
    let coverColor: String
    let titleColor: String
    let title: String
    let illust: String?
    let linkCount: Int
    let isDefault: Bool
  }

  // MARK: UI

  private let shadowView = UIView().then {
    $0.clipsToBounds = false
  }

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

  private let illust = UIImageView()

  private let countLabel = UILabel()

  private let buttonContainer = UIView().then {
    $0.layer.cornerRadius = 32 / 2
    $0.backgroundColor = .staticBlack
    $0.clipsToBounds = true
  }

  let moreButton = UIButton().then {
    $0.setImage(DesignSystemAsset.iconMoreVertical.image.withTintColor(.gray100), for: .normal)
  }

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
    folderCover.backgroundColor = .clear
    disposeBag = DisposeBag()
    buttonContainer.isHidden = false
  }


  // MARK: Configuring

  func configure(viewModel: ViewModel) {
    folderCover.backgroundColor = UIColor(hexString: viewModel.coverColor)

    folderTitle.do {
      $0.attributedText = viewModel.title.styled(
        font: .bodyBold,
        color: UIColor(hexString: viewModel.titleColor)
      )
    }

    if let image = viewModel.illust {
      illust.image = UIImage(
        named: image,
        in: DesignSystemResources.bundle,
        compatibleWith: nil
      )
    }

    countLabel.do {
      $0.attributedText = "\(viewModel.linkCount)개".styled(
        font: .captionRegular,
        color: .gray700
      )
    }

    buttonContainer.isHidden = viewModel.isDefault
  }


  // MARK: Layout

  private func setFolderCorverView() {
    // 그림자 설정
    shadowView.layer.cornerRadius = 8
    shadowView.layer.shadowColor = UIColor.black.cgColor
    shadowView.layer.shadowOpacity = 0.1
    shadowView.layer.shadowOffset = CGSize(width: 0, height: 4)
    shadowView.layer.shadowRadius = 2

    // 그림자 경로 설정 (코너 반경을 고려)
    let bounds = CGRect(
      x: contentView.bounds.minX,
      y: contentView.bounds.minY,
      width: contentView.bounds.width,
      height: contentView.bounds.height - 26
    )

    shadowView.layer.shadowPath = UIBezierPath(
      roundedRect: bounds,
      cornerRadius: shadowView.layer.cornerRadius
    ).cgPath
  }

  private func defineLayout() {
    [shadowView, folderCover, illust, folderTitle, verticalBar, buttonContainer, countLabel].forEach {
      contentView.addSubview($0)
    }
    buttonContainer.addSubview(moreButton)

    shadowView.snp.makeConstraints {
      $0.edges.equalTo(folderCover)
    }

    folderCover.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
    }

    illust.snp.makeConstraints {
      $0.size.equalTo(72.0)
      $0.right.bottom.equalTo(folderCover).inset(8.0)
    }

    verticalBar.snp.makeConstraints {
      $0.left.equalToSuperview().inset(8.0)
      $0.top.bottom.equalTo(folderCover)
      $0.width.equalTo(2.0)
    }

    folderTitle.snp.makeConstraints {
      $0.right.equalToSuperview().inset(10.0)
      $0.top.equalToSuperview().inset(16.0)
      $0.left.equalTo(verticalBar.snp.right).offset(8.0)
    }

    countLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(folderCover.snp.bottom).offset(12.0)
      $0.bottom.equalToSuperview()
    }

    buttonContainer.snp.makeConstraints {
      $0.size.equalTo(32.0)
      $0.right.bottom.equalTo(folderCover).inset(8.0)
    }

    moreButton.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  override func layoutSubviews() {
    setFolderCorverView()
  }
}
