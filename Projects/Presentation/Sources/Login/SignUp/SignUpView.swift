import UIKit

import SnapKit
import Then

import DesignSystem

final class SignUpView: UIView {

  // MARK: UI

  private let container = UIView()

  private let titleLabel = UILabel().then {
    $0.text = "만나서 반가워요!\n성별과 연령을 입력해주세요."
    $0.font = .titleRegular
    $0.textColor = .staticBlack
    $0.numberOfLines = 0
  }

  private let subtitle = UILabel().then {
    $0.text = "※"
    $0.font = .captionRegular
    $0.textColor = .gray600
    $0.numberOfLines = 0
  }

  private let subtitleLabel = UILabel().then {
    $0.text = "입력한 성별/연령 정보는 주섬 앱 개선을 위해서만 사용되며\n다른 용도로 사용되지 않아요."
    $0.font = .captionRegular
    $0.textColor = .gray600
    $0.numberOfLines = 0
  }

  let genderView = SignUpGenderView()

  let ageInputField = InputField(type: .dropdown).then {
    $0.title = "출생연도를 선택해주세요"
    $0.placeHolder = "선택"
  }

  let completeButton = BasicButton(priority: .primary).then {
    $0.text = "완료"
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

    [titleLabel, subtitle, subtitleLabel, genderView, ageInputField, completeButton].forEach {
      container.addSubview($0)
    }

    container.snp.makeConstraints {
      $0.top.bottom.equalTo(safeAreaLayoutGuide)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(24.0)
      $0.left.right.equalToSuperview()
    }

    subtitle.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(4.0)
      $0.left.equalToSuperview()
    }

    subtitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(4.0)
      $0.left.equalTo(subtitle.snp.right).offset(4.0)
      $0.right.equalToSuperview()
    }

    genderView.snp.makeConstraints {
      $0.top.equalTo(subtitleLabel.snp.bottom).offset(40.0)
      $0.left.right.equalToSuperview()
    }

    ageInputField.snp.makeConstraints {
      $0.top.equalTo(genderView.snp.bottom).offset(44.0)
      $0.left.right.equalToSuperview()
    }

    completeButton.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.bottom.equalToSuperview().inset(20.0)
    }
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    endEditing(true)
  }
}
