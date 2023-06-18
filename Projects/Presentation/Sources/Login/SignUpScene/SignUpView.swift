import UIKit

import SnapKit
import Then

import DesignSystem

final class SignUpView: UIView {
  // MARK: UI

  private let container = UIView()

  let nicknameTextField = InputField(type: .normal).then {
    $0.title = "Nickname"
    $0.placeHolder = "닉네임 입력 고고"
  }

  let ageTextField = InputField(type: .normal).then {
    $0.title = "Age"
    $0.placeHolder = "나이 숫자로 입력하세요."
    $0.keyboardType = .numberPad
  }

  let genderTextField = InputField(type: .normal).then {
    $0.title = "Gender"
    $0.placeHolder = "성별 m(남),w(여) 입력하세요."
  }

  let signUpButton = BasicButton(priority: .primary).then {
    $0.text = "Sign Up"
    $0.isEnabled = false
  }

  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .gray100

    defineLayout()
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Layout

  private func defineLayout() {
    addSubview(container)

    [nicknameTextField, ageTextField, genderTextField, signUpButton].forEach {
      container.addSubview($0)
    }

    container.snp.makeConstraints {
      $0.top.bottom.equalTo(self.safeAreaLayoutGuide)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    nicknameTextField.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
    }

    ageTextField.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.top.equalTo(nicknameTextField.snp.bottom).offset(20.0)
    }

    genderTextField.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.top.equalTo(ageTextField.snp.bottom).offset(20.0)
    }

    signUpButton.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.bottom.equalToSuperview().inset(20.0)
    }
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    endEditing(true)
  }
}
