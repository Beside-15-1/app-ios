import UIKit

import FlexLayout
import PinLayout
import RxCocoa
import RxSwift
import SnapKit
import Then

import DesignSystem

final class HomeView: UIView {

  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .gray300
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()

//    container.pin.all(pin.safeArea)
//    container.flex.layout()
  }
}
