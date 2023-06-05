import UIKit

import FlexLayout
import PinLayout
import SnapKit
import Then

import DesignSystem

final class MyPageView: UIView {
  // TODO: 테스트용
  let logoutButton = UIButton().then {
    $0.setTitle("LOGOUT", for: .normal)
    $0.setTitleColor(.black, for: .normal)
  }

  let enableButton = BasicButton(priority: .primary).then {
    $0.text = "Enabled"
  }

  let disableButton = BasicButton(priority: .primary).then {
    $0.text = "Disabled"
    $0.isEnabled = false
  }

  let textButtonRegular = TextButton(type: .regular).then {
    $0.leftIconImage = DesignSystemAsset.iconPlus.image
    $0.rightIconImage = DesignSystemAsset.iconRight.image
    $0.text = "Regular"
  }

  let textButtonSmall = TextButton(type: .small).then {
    $0.leftIconImage = DesignSystemAsset.iconPlus.image
    $0.rightIconImage = DesignSystemAsset.iconRight.image
    $0.text = "Small"
  }

  let searchInputField = InputField(type: .search).then {
    $0.placeHolder = "Title, Search, Error"
    $0.title = "Title"
    $0.errorDescription = "error text"
    $0.showError()
  }

  let normarInputField = InputField(type: .normal).then {
    $0.placeHolder = "No Title, Normal, No Error, Disabled"
    $0.isEnabled = false
  }

  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .gray100

    addSubview(logoutButton)
    addSubview(enableButton)
    addSubview(disableButton)
    addSubview(textButtonRegular)
    addSubview(textButtonSmall)
    addSubview(searchInputField)
    addSubview(normarInputField)

    logoutButton.snp.makeConstraints {
      $0.bottom.centerX.equalTo(safeAreaLayoutGuide)
    }

    enableButton.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide).inset(20.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    disableButton.snp.makeConstraints {
      $0.top.equalTo(enableButton.snp.bottom).offset(20.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    textButtonRegular.snp.makeConstraints {
      $0.top.equalTo(disableButton.snp.bottom).offset(20.0)
      $0.centerX.equalToSuperview()
    }

    textButtonSmall.snp.makeConstraints {
      $0.top.equalTo(textButtonRegular.snp.bottom).offset(20.0)
      $0.centerX.equalToSuperview()
    }

    searchInputField.snp.makeConstraints {
      $0.top.equalTo(textButtonSmall.snp.bottom).offset(20.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    normarInputField.snp.makeConstraints {
      $0.top.equalTo(searchInputField.snp.bottom).offset(20.0)
      $0.left.right.equalToSuperview().inset(20.0)
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
