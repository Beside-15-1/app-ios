import UIKit

import FlexLayout
import PinLayout
import SnapKit
import Then

import DesignSystem

final class TermsOfUseView: UIView {
  // MARK: UI

  private let container = UIView()

  private let titleLabel = UILabel().then {
    $0.text = "서비스 이용을 위한 이용약관 동의"
    $0.font = .defaultSemiBold
    $0.textColor = .gray900
  }

  let closeButton = UIButton().then {
    $0.setImage(DesignSystemAsset.iconCloseOutline.image.withTintColor(.gray900), for: .normal)
  }

  private let divider = UIView().then {
    $0.backgroundColor = UIColor(hexString: "#E0E0E0")
  }

  let checkAllButton = TermsOfUseAllCheckView()
  let checkServiceButton = TermsOfUseServiceView()
  let checkPersonalButton = TermsOfUsePersonalView()

  let nextButton = BasicButton(priority: .primary).then {
    $0.text = "다음"
    $0.isEnabled = false
  }

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

  private func defineLayout() {
    addSubview(container)
    addSubview(divider)
    [
      titleLabel,
      closeButton,
      checkAllButton,
      checkServiceButton,
      checkPersonalButton,
      nextButton
    ]
    .forEach { container.addSubview($0) }

    container.snp.makeConstraints {
      $0.top.bottom.equalTo(safeAreaLayoutGuide)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    titleLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(18.0)
    }

    closeButton.snp.makeConstraints {
      $0.centerY.equalTo(titleLabel)
      $0.right.equalToSuperview()
      $0.size.equalTo(CGSize(width: 24.0, height: 24.0))
    }

    divider.snp.makeConstraints {
      $0.height.equalTo(1.0)
      $0.top.equalTo(titleLabel.snp.bottom).offset(18.0)
      $0.left.right.equalToSuperview()
    }

    checkAllButton.snp.makeConstraints {
      $0.top.equalTo(divider.snp.bottom).offset(20.0)
      $0.left.right.equalToSuperview()
    }

    checkServiceButton.snp.makeConstraints {
      $0.top.equalTo(checkAllButton.snp.bottom).offset(8.0)
      $0.left.right.equalToSuperview()
    }

    checkPersonalButton.snp.makeConstraints {
      $0.top.equalTo(checkServiceButton.snp.bottom).offset(8.0)
      $0.left.right.equalToSuperview()
    }

    nextButton.snp.makeConstraints {
      $0.top.equalTo(checkPersonalButton.snp.bottom).offset(32.0)
      $0.left.right.equalToSuperview()
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
