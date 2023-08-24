import UIKit

import SnapKit
import Then

import DesignSystem

final class TagAddTitleView: UIView {
  // MARK: UI

  private let container = UIView()

  private let titleLabel = UILabel().then {
    $0.text = "태그 추가"
    $0.textColor = .gray900
    $0.font = .defaultSemiBold
  }

  let closeButton = UIButton().then {
    $0.setImage(
      DesignSystemAsset.iconCloseOutline.image.withTintColor(.gray900),
      for: .normal
    )
  }

  private let divider = UIView().then {
    $0.backgroundColor = UIColor(hexString: "#E0E0E0")
  }

  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  // MARK: Layout

  private func defineLayout() {
    addSubview(container)

    [titleLabel, closeButton, divider].forEach { container.addSubview($0) }

    container.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.height.equalTo(60.0)
    }

    titleLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }

    closeButton.snp.makeConstraints {
      $0.right.equalToSuperview().inset(20.0)
      $0.centerY.equalToSuperview()
      $0.size.equalTo(24.0)
    }

    divider.snp.makeConstraints {
      $0.left.right.bottom.equalToSuperview()
      $0.height.equalTo(1.0)
    }
  }
}
