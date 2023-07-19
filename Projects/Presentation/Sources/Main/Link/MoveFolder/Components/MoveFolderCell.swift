//
//  MoveFolderCell.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/19.
//

import Foundation
import UIKit

import SnapKit
import Then
import SDWebImage

import DesignSystem
import Domain

class MoveFolderCell: UICollectionViewCell {

  static let identifier = "MoveFolderCell"

  struct ViewModel: Hashable {
    let id: String
    let coverColor: String
    let titleColor: String
    let title: String
    let illust: String?
    let isCurrentFolder: Bool
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

  private let currentView = UIView().then {
    $0.backgroundColor = .staticBlack.withAlphaComponent(0.6)
    $0.isHidden = true
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 8
  }

  private let currentLabel = UILabel().then {
    $0.attributedText = "저장된 폴더".styled(font: .captionSemiBold, color: .staticWhite)
  }

  private let checkView = UIView().then {
    $0.backgroundColor = .black.withAlphaComponent(0.6)
    $0.isHidden = true
    $0.clipsToBounds = true
    $0.layer.cornerRadius = 8
  }

  private let checkIcon = UIImageView().then {
    $0.image = DesignSystemAsset.iconCheckFill.image.withTintColor(.white)
  }

  // MARK: Configuring

  override var isSelected: Bool {
    didSet {
      guard isSelected != oldValue else { return }
      configure(isSelected: isSelected)
    }
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
    folderCover.backgroundColor = .clear
    currentView.isHidden = true
    checkView.isHidden = true
    configure(isSelected: false)
  }


  // MARK: Configuring

  func configure(viewModel: ViewModel) {

    currentView.isHidden = !viewModel.isCurrentFolder

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
  }

  func configure(isSelected: Bool) {
    checkView.isHidden = !isSelected
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
    [folderCover, illust, folderTitle, verticalBar, currentView, checkView].forEach { contentView.addSubview($0) }
    currentView.addSubview(currentLabel)
    checkView.addSubview(checkIcon)

    folderCover.snp.makeConstraints {
      $0.edges.equalToSuperview()
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

    currentView.snp.makeConstraints {
      $0.left.right.bottom.equalToSuperview()
      $0.height.equalTo(28.0)
    }

    currentLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }

    checkView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    checkIcon.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.size.equalTo(24.0)
    }
  }

  override func layoutSubviews() {
    setFolderCorverView()
  }
}
