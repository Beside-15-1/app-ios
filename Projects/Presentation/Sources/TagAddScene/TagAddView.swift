import UIKit

import FlexLayout
import PinLayout
import SnapKit
import Then

import DesignSystem

final class TagAddView: UIView {
  // MARK: UI

  let titleView = TagAddTitleView()

  let inputField = InputField(type: .normal).then {
    $0.placeHolder = "태그를 선택 또는 생성 해주세요."
  }

  let addedTagView = AddedTagView().then {
    $0.applyAddedTag(by: ["asdsf1", "asdsf", "asd1", "a123sdsf1", "as151dsf1", "3asdsf1"])
  }

  let tagListView = TagListView().then {
    $0.applyTagList(by: ["asdsf1", "asdsf", "asd1", "a123sdsf1", "as151dsf1", "3asdsf1"])
  }

  let makeButton = BasicButton(priority: .primary).then {
    $0.text = "만들기"
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
    [titleView, inputField, addedTagView, tagListView, makeButton].forEach {
      addSubview($0)
    }

    titleView.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
    }

    inputField.snp.makeConstraints {
      $0.top.equalTo(titleView.snp.bottom).offset(20.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    addedTagView.snp.makeConstraints {
      $0.top.equalTo(inputField.snp.bottom).offset(16.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    tagListView.snp.makeConstraints {
      $0.top.equalTo(addedTagView.snp.bottom).offset(36.0)
      $0.left.right.equalToSuperview().inset(20.0)
      $0.bottom.equalTo(makeButton.snp.top).offset(-12.0)
    }

    makeButton.snp.makeConstraints {
      $0.bottom.left.right.equalTo(safeAreaLayoutGuide).inset(20.0)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
