import UIKit

import SnapKit
import Then

import DesignSystem

protocol SignUpViewDelegate: AnyObject {
  func inputFieldDidSelectYear(year: Int)
}

final class SignUpView: UIView {

  // MARK: UI

  private let container = UIView()

  private let titleLabel = UILabel().then {
    $0.attributedText = "만나서 반가워요!\n성별과 연령을 입력해주세요."
      .styled(
        font: .titleBold,
        color: .staticBlack
      )
    $0.numberOfLines = 0
  }

  private let subtitle = UILabel().then {
    $0.attributedText = "※".styled(font: .captionRegular, color: .gray600)
    $0.numberOfLines = 0
  }

  private let subtitleLabel = UILabel().then {
    $0.attributedText = "입력한 성별/연령 정보는 주섬 앱 개선을 위해서만 사용되며\n다른 용도로 사용되지 않아요."
      .styled(font: .captionRegular, color: .gray600)
    $0.numberOfLines = 0
  }

  let genderView = SignUpGenderView()

  lazy var ageInputField = InputField(type: .dropdown).then {
    $0.title = "출생연도를 선택해주세요".styled(font: .subTitleSemiBold, color: .staticBlack)
    $0.placeHolder = "선택"
    $0.textFieldInputView = pickerView
    $0.textFieldInputAccessoryView = toolbar
  }

  let completeButton = BasicButton(priority: .primary).then {
    $0.text = "완료"
  }

  private let years = Array(Array((Calendar.current.component(.year, from: Date()) - 100)...Calendar.current.component(.year, from: Date())).reversed())

  private lazy var pickerView = UIPickerView().then {
    $0.delegate = self
    $0.dataSource = self
  }

  private lazy var toolbar = UIToolbar().then {
    $0.sizeToFit()
    $0.setItems([flexibleSpace, doneButton], animated: true)
  }

  private lazy var flexibleSpace = UIBarButtonItem(
    barButtonSystemItem: .flexibleSpace, target: nil, action: nil
  )

  private lazy var doneButton = UIBarButtonItem(
    barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped)
  )


  // MARK: Properties

  weak var delegate: SignUpViewDelegate?


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .paperWhite

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
      $0.top.equalToSuperview().inset(24.0)
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

  @objc
  private func doneButtonTapped() {
    let selectedRow = pickerView.selectedRow(inComponent: 0)
    let selectedYear = years[selectedRow]

    // 선택된 년도를 UITextField에 설정합니다.
    ageInputField.text = "\(selectedYear)년"
    delegate?.inputFieldDidSelectYear(year: selectedYear)

    // UITextField의 입력 포커스를 해제합니다.
    ageInputField.resignFirstResponder()
  }
}


extension SignUpView: UIPickerViewDelegate, UIPickerViewDataSource {
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    years.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    let year = years[row]
    return "\(year)년"
  }
}
