import UIKit

import RxSwift
import SnapKit
import Then

import DesignSystem

class AddedTagCell: UICollectionViewCell {
  static let identifier = "AddedTagCell"

  private enum Metric {
    static let height: CGFloat = 28.0
  }

  // MARK: UI

  private let container = UIView().then {
    $0.backgroundColor = .gray300
    $0.clipsToBounds = true
    $0.layer.cornerRadius = Metric.height / 2
  }

  private let textLabel = UILabel().then {
    $0.font = .captionRegular
    $0.textColor = .staticBlack
    $0.textAlignment = .center
  }

  let deleteButton = UIButton().then {
    $0.setImage(DesignSystemAsset.iconCloseFill.image.withTintColor(.gray500), for: .normal)
  }

  var disposeBag = DisposeBag()

  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override func prepareForReuse() {
    disposeBag = DisposeBag()
  }

  // MARK: Configuring

  func configureText(text: String) {
    textLabel.text = text
  }

  // MARK: Layout

  private func defineLayout() {
    contentView.addSubview(container)
    [textLabel, deleteButton].forEach { container.addSubview($0) }

    container.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    textLabel.snp.makeConstraints {
      $0.left.equalToSuperview().inset(8.0)
      $0.top.bottom.equalToSuperview().inset(4.0)
    }

    deleteButton.snp.makeConstraints {
      $0.left.equalTo(textLabel.snp.right).offset(2.0)
      $0.right.equalToSuperview().inset(8.0)
      $0.centerY.equalToSuperview()
      $0.size.equalTo(16.0)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
