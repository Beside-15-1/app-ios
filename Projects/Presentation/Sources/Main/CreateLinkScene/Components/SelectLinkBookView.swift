import UIKit

import SnapKit
import Then

import DesignSystem

final class SelectLinkBookView: UIView {
  // MARK: Constant

  private enum Metric {
    static let linkBookIconSize = CGSize(width: 19.0, height: 19.0)
    static let caretDownSize = CGSize(width: 24.0, height: 24.0)
  }

  // MARK: UI

  private let titleLabel = UILabel().then {
    $0.text = "저장할 링크북"
    $0.textColor = .staticBlack
    $0.font = .subTitleSemiBold
  }

  let container = UIControl().then {
    $0.backgroundColor = .gray200
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
  }

  private let linkBookColorView = UIView().then {
    $0.layer.cornerRadius = Metric.linkBookIconSize.height / 2
  }

  private let linkBookTitleLabel = UILabel().then {
    $0.font = .defaultRegular
    $0.textColor = .staticBlack
  }

  private let dropDownImage = UIImageView().then {
    $0.image = DesignSystemAsset.iconDown.image.withTintColor(.gray500)
  }

  let createLinkBookButton = TextButton(type: .regular, color: .primary500).then {
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

  // MARK: Layout

  private func defineLayout() {
    [titleLabel, createLinkBookButton, container].forEach { addSubview($0) }
    [linkBookColorView, linkBookTitleLabel, dropDownImage].forEach { container.addSubview($0) }

    titleLabel.snp.makeConstraints {
      $0.left.top.equalToSuperview()
    }

    createLinkBookButton.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.right.equalToSuperview().inset(4.0)
    }

    container.snp.makeConstraints {
      $0.height.equalTo(48.0)
      $0.left.right.bottom.equalToSuperview()
      $0.top.equalTo(titleLabel.snp.bottom).offset(8.0)
    }

    linkBookColorView.snp.makeConstraints {
      $0.left.equalToSuperview().inset(12.0)
      $0.centerY.equalToSuperview()
      $0.size.equalTo(Metric.linkBookIconSize)
    }

    linkBookTitleLabel.snp.makeConstraints {
      $0.left.equalTo(linkBookColorView.snp.right).offset(8.0)
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
