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

protocol FolderDetailCellDelegate: AnyObject {
  func folderDetailCellCheckBoxTapped(id: String)
  func folderDetailCellMoreButtonTapped(id: String)
}

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
    let readCount: Int
    var isEditing: Bool = false
  }

  // MARK: UI

  private let container = UIView()

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

  private let folderContainer = UIView().then {
    $0.backgroundColor = .gray200
    $0.layer.cornerRadius = 12
    $0.clipsToBounds = true
  }

  private let folderLabel = UILabel()

  private let readCountLabel = UILabel()

  let checkBox = CheckBox(type: .fill)


  // MARK: Properties

  var disposeBag = DisposeBag()

  weak var delegate: FolderDetailCellDelegate?

  var viewModel: ViewModel?


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
//    addAction()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    checkBox.isSelected = false
    disposeBag = DisposeBag()
  }


  // MARK: Configuring

  func configure(viewModel: ViewModel) {
    self.viewModel = viewModel

    titleLabel.do {
      $0.attributedText = viewModel.title.styled(font: .subTitleBold, color: .staticBlack)
    }

    tagLabel.do {
      let tagText = viewModel.tags.reduce("") { $0 + "#\($1) " }
      $0.attributedText = tagText.styled(font: .bodyRegular, color: .gray800)
    }

    captionLabel.do {
      var caption = ""

      if let url = URL(string: viewModel.url) {
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        urlComponents?.path = ""

        // URL
        let prefixes = ["https://", "http://", "www."]
        caption = urlComponents?.host ?? ""

        for prefix in prefixes {
          if caption.hasPrefix(prefix) {
            caption = String(caption.dropFirst(prefix.count))
          }
        }
      }

      // Date
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

      let date = dateFormatter.date(from: viewModel.createAt)
      dateFormatter.dateFormat = "yy.MM.dd"

      let stringFromDate = dateFormatter.string(from: date ?? Date())

      caption += " | \(stringFromDate)"

      $0.attributedText = caption.styled(font: .captionRegular, color: .gray700)
    }

    if let thumbnailURL = viewModel.thumbnailURL, !thumbnailURL.isEmpty {
      thumbnail.sd_setImage(
        with: URL(string: thumbnailURL),
        placeholderImage: DesignSystemAsset.homeLinkEmptyImage.image
      )
    } else {
      thumbnail.image = DesignSystemAsset.homeLinkEmptyImage.image
    }

    // Folder
    folderLabel.attributedText = viewModel.folderName
      .styled(font: .captionSemiBold, color: .gray700)

    if viewModel.readCount == 0 {
      readCountLabel.attributedText = "읽지 않음"
        .styled(font: .captionSemiBold, color: .primary400)
    } else {
      readCountLabel.attributedText = "\(viewModel.readCount)회 읽음"
        .styled(font: .captionSemiBold, color: .gray700)
    }

    if viewModel.isEditing {
      container.transform = CGAffineTransform.init(translationX: 36.0, y: 0)
      moreButton.isHidden = true
    } else {
      container.transform = .identity
      checkBox.isSelected = false
      moreButton.isHidden = false
    }
  }

  private func addAction() {
    checkBox.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.delegate?.folderDetailCellCheckBoxTapped(id: self.viewModel?.id ?? "")
      }
      .disposed(by: disposeBag)

    moreButton.rx.controlEvent(.touchUpInside)
      .subscribe(with: self) { `self`, _ in
        self.delegate?.folderDetailCellMoreButtonTapped(id: self.viewModel?.id ?? "")
      }
      .disposed(by: disposeBag)
  }


  // MARK: Layout

  private func defineLayout() {
    [checkBox, container].forEach { contentView.addSubview($0) }
    [titleLabel, thumbnail, tagLabel, captionLabel, moreButton, underLine, folderContainer, readCountLabel].forEach {
      container.addSubview($0)
    }

    checkBox.snp.makeConstraints {
      $0.left.equalToSuperview()
      $0.centerY.equalToSuperview()
    }

    container.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    folderContainer.addSubview(folderLabel)

    thumbnail.snp.makeConstraints {
      $0.width.equalTo(82)
      $0.height.equalTo(108)
      $0.left.equalToSuperview()
      $0.top.bottom.equalToSuperview().inset(20.0)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(folderContainer.snp.bottom).offset(4.0)
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

    folderContainer.snp.makeConstraints {
      $0.top.equalToSuperview().inset(20.0)
      $0.left.equalTo(thumbnail.snp.right).offset(12.0)
      $0.height.equalTo(24.0)
    }

    folderLabel.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(8.0)
      $0.centerY.equalToSuperview()
    }

    readCountLabel.snp.makeConstraints {
      $0.left.equalTo(folderContainer.snp.right).offset(8.0)
      $0.centerY.equalTo(folderLabel)
      $0.right.lessThanOrEqualToSuperview()
    }
  }
}
