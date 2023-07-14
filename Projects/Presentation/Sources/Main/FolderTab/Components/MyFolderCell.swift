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
  }


  // MARK: Layout

  private func setFolderCorverView() {
    // 코너 반경 설정
    folderCover.layer.cornerRadius = 8

    // 그림자 설정
    folderCover.layer.shadowColor = UIColor.black.cgColor
    folderCover.layer.shadowOpacity = 0.1
    folderCover.layer.shadowOffset = CGSize(width: 0, height: 4)
    folderCover.layer.shadowRadius = 2

    // 그림자 경로 설정 (코너 반경을 고려)
    folderCover.layer.shadowPath = UIBezierPath(
      roundedRect: contentView.bounds,
      cornerRadius: contentView.layer.cornerRadius
    ).cgPath
  }

  private func defineLayout() {
    [folderCover, illust, folderTitle, verticalBar, buttonContainer, countLabel].forEach {
      contentView.addSubview($0)
    }
    buttonContainer.addSubview(moreButton)

    folderCover.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
    }

    illust.snp.makeConstraints {
      $0.size.equalTo(95.0)
      $0.right.equalToSuperview().inset(2.0)
      $0.bottom.equalToSuperview()
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
