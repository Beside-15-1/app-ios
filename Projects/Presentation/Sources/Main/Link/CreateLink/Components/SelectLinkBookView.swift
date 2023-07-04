import UIKit

import SnapKit
import Then

import Domain
import DesignSystem

final class SelectFolderButton: UIView {
  // MARK: Constant

  private enum Metric {
    static let folderIconSize = CGSize(width: 19.0, height: 19.0)
    static let caretDownSize = CGSize(width: 24.0, height: 24.0)
  }

  // MARK: UI

  private let titleLabel = UILabel().then {
    $0.text = "저장할 폴더"
    $0.textColor = .staticBlack
    $0.font = .subTitleSemiBold
  }

  let container = UIControl().then {
    $0.backgroundColor = .gray200
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
    $0.layer.borderColor = UIColor.primary500.cgColor
  }

  private let folderTitleLabel = UILabel().then {
    $0.font = .defaultRegular
    $0.textColor = .gray600 
    $0.text = "기본"
  }

  private let dropDownImage = UIImageView().then {
    $0.image = DesignSystemAsset.iconDown.image.withTintColor(.gray500)
  }

  let createFolderButton = TextButton(type: .regular, color: .primary500).then {
    $0.leftIconImage = DesignSystemAsset.iconPlus.image
    $0.text = "새폴더"
  }

  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  func configure(withFolder folder: Folder) {
    folderTitleLabel.text = folder.title
  }

  func select() {
    container.backgroundColor = .primary100
    container.layer.borderWidth = 1
  }

  func deselect() {
    container.backgroundColor = .gray200
    container.layer.borderWidth = 0
  }

  // MARK: Layout

  private func defineLayout() {
    [titleLabel, createFolderButton, container].forEach { addSubview($0) }
    [folderTitleLabel, dropDownImage].forEach { container.addSubview($0) }

    titleLabel.snp.makeConstraints {
      $0.left.top.equalToSuperview()
    }

    createFolderButton.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.right.equalToSuperview().inset(4.0)
    }

    container.snp.makeConstraints {
      $0.height.equalTo(48.0)
      $0.left.right.bottom.equalToSuperview()
      $0.top.equalTo(titleLabel.snp.bottom).offset(8.0)
    }

    folderTitleLabel.snp.makeConstraints {
      $0.left.equalToSuperview().inset(12.0)
      $0.centerY.equalToSuperview()
    }

    dropDownImage.snp.makeConstraints {
      $0.right.equalToSuperview().inset(12.0)
      $0.centerY.equalToSuperview()
      $0.size.equalTo(Metric.caretDownSize)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
