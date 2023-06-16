import UIKit

import FlexLayout
import PinLayout
import SnapKit
import Then

import DesignSystem

final class TagAddView: UIView {
  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .paperWihte

    defineLayout()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Layout

  private func defineLayout() {}

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
