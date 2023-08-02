import UIKit

import SnapKit
import Then

import DesignSystem

final class CreateLinkView: UIView {
  // MARK: UI

  private let colorBackground = UIView().then {
    $0.backgroundColor = .paperAboveBg
  }

  let titleLabel = UILabel().then {
    $0.attributedText = "링크 저장".styled(font: .defaultRegular, color: .white)
  }

  let closeButton = UIButton().then {
    $0.setImage(
      DesignSystemAsset.iconCloseOutline.image.withTintColor(.white),
      for: .normal
    )
  }

  let linkInputField = InputField(type: .normal).then {
    $0.title = "링크".styled(font: .subTitleSemiBold, color: .white)
    $0.placeHolder = "URL을 입력하거나 붙여넣어주세요."
    $0.returnKeyType = .done
    $0.tag = 1
  }

  let titleInputField = InputField(type: .normal).then {
    $0.title = "제목".styled(font: .subTitleSemiBold, color: .staticBlack)
    $0.placeHolder = "제목을 입력해주세요."
    $0.tag = 2
    $0.returnKeyType = .done
  }

  let selectFolderView = SelectFolderButton()

  let tagView = TagView()

  let saveButton = BasicButton(priority: .primary).then {
    $0.text = "저장"
  }

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

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)

    endEditing(true)
  }

  // MARK: Layout

  private func defineLayout() {
    [colorBackground, titleInputField, selectFolderView, tagView, saveButton].forEach {
      addSubview($0)
    }
    [titleLabel, closeButton, linkInputField].forEach { colorBackground.addSubview($0) }

    colorBackground.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide).offset(10.0)
      $0.centerX.equalToSuperview()
    }

    closeButton.snp.makeConstraints {
      $0.centerY.equalTo(titleLabel)
      $0.right.equalToSuperview().inset(20.0)
      $0.size.equalTo(24.0)
    }

    linkInputField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(30.0)
      $0.left.right.equalToSuperview().inset(20.0)
      $0.bottom.equalToSuperview().inset(24.0)
    }

    titleInputField.snp.makeConstraints {
      $0.top.equalTo(colorBackground.snp.bottom).offset(30.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    selectFolderView.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(20.0)
      $0.top.equalTo(titleInputField.snp.bottom).offset(54.0)
    }

    tagView.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(20.0)
      $0.top.equalTo(selectFolderView.snp.bottom).offset(32.0)
    }

    saveButton.snp.makeConstraints {
      $0.left.right.bottom.equalTo(safeAreaLayoutGuide).inset(20.0)
      $0.top.equalTo(tagView.snp.bottom).offset(13.0)
    }

  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
