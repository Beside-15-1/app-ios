import UIKit

import FlexLayout
import PinLayout
import SnapKit
import Then

import DesignSystem

// MARK: - MyPageView

final class MyPageView: UIView {
  // TODO: 테스트용
  let logoutButton = TextButton(type: .regular).then {
    $0.text = "LOGOUT"
  }

  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .paperGray

    addSubview(logoutButton)

    logoutButton.snp.makeConstraints {
      $0.bottom.centerX.equalTo(safeAreaLayoutGuide)
    }
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    endEditing(true)
  }
}
