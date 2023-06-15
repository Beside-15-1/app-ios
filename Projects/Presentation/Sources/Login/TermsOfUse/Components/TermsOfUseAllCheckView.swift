import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem

final class TermsOfUseAllCheckView: UIControl {
  override var isSelected: Bool {
    didSet {
      guard isSelected != oldValue else { return }
      checkBox.isSelected = isSelected
    }
  }

  // MARK: UI

  private let container = UIView().then {
    $0.isUserInteractionEnabled = false
    $0.layer.cornerRadius = 8
    $0.layer.borderWidth = 1
  }

  private let checkBox = CheckBox().then {
    $0.isUserInteractionEnabled = false
  }

  private let titleLabel = UILabel().then {
    $0.text = "전체 동의"
    $0.font = .defaultSemiBold
    $0.textColor = .gray900
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

    [checkBox, titleLabel].forEach { addSubview($0) }

    container.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    checkBox.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(10)
      $0.left.equalToSuperview().inset(10)
    }

    titleLabel.snp.makeConstraints {
      $0.left.equalTo(checkBox.snp.right).offset(8)
      $0.centerY.equalToSuperview()
    }
  }

  override func layoutSubviews() {
    container.layer.borderColor = UIColor.gray500.cgColor
  }
}
