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

  let enableButton = BasicButton(priority: .primary).then {
    $0.text = "태그"
  }

  let disableButton = BasicButton(priority: .primary).then {
    $0.text = "Disabled"
    $0.isEnabled = false
  }

  let textStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.spacing = 8.0
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

  let fab = FAB()

  lazy var tab = TabView().then {
    $0.applyTabs(by: ["MENU", "업무용", "공부", "디자인", "학습", "간다라마바사간다라마자다마라ㅏㄷ라ㅏ자마마ㅏ잘만아란ㅁ람ㄴ아팜ㄴㅍ만팡ㅁ낲ㄴ마팡ㄴ맢ㅁ낲"])
  }

  let tabDelegateLabel = UILabel().then {
    $0.font = .bodySemiBold
    $0.textColor = .gray900
  }

  let tabRelayLabel = UILabel().then {
    $0.font = .bodySemiBold
    $0.textColor = .gray900
  }

  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .paperGray

    addSubview(logoutButton)
    addSubview(enableButton)
    addSubview(disableButton)
    addSubview(textStackView)
    [textButtonRegular, textButtonSmall].forEach { textStackView.addArrangedSubview($0) }
    addSubview(searchInputField)
    addSubview(normarInputField)
    addSubview(fab)
    addSubview(tab)
    [tabDelegateLabel, tabRelayLabel].forEach { addSubview($0) }

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

    textStackView.snp.makeConstraints {
      $0.top.equalTo(disableButton.snp.bottom).offset(20.0)
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

    tab.snp.makeConstraints {
      $0.top.equalTo(normarInputField.snp.bottom).offset(20.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    tabDelegateLabel.snp.makeConstraints {
      $0.top.equalTo(tab.snp.bottom).offset(20.0)
      $0.centerX.equalToSuperview().offset(-50.0)
    }

    tabRelayLabel.snp.makeConstraints {
      $0.top.equalTo(tab.snp.bottom).offset(20.0)
      $0.centerX.equalToSuperview().offset(50.0)
    }

    fab.snp.makeConstraints {
      $0.right.equalToSuperview().inset(20.0)
      $0.bottom.equalTo(safeAreaLayoutGuide).inset(10.0)
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
