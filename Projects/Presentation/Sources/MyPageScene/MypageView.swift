import UIKit

import FlexLayout
import PinLayout
import SnapKit
import Then

import DesignSystem

final class MyPageView: UIView {
  // TODO: 테스트용
  let testButton = UIButton().then {
    $0.setTitle("LOGOUT", for: .normal)
    $0.setTitleColor(.black, for: .normal)
  }

  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .gray100

    addSubview(testButton)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()
    testButton.pin.center().sizeToFit()
  }
}
