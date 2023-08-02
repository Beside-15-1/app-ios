//
//  ManageTagView.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/22.
//

import UIKit

import SnapKit
import Then

import DesignSystem

final class ManageTagView: UIView {

  // MARK: UI

  let inputField = InputField(type: .normal).then {
    $0.placeHolder = "태그를 생성하여 목록에 추가해보세요."
    $0.returnKeyType = .done
  }

  let tagListView = TagListView()

  let saveButton = BasicButton(priority: .primary).then {
    $0.text = "저장"
  }

  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.backgroundColor = .paperWhite

    defineLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(inputField)
    addSubview(tagListView)
    addSubview(saveButton)

    inputField.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide).inset(24.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    tagListView.snp.makeConstraints {
      $0.top.equalTo(inputField.snp.bottom).offset(24.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    saveButton.snp.makeConstraints {
      $0.left.right.bottom.equalTo(safeAreaLayoutGuide).inset(20.0)
      $0.top.equalTo(tagListView.snp.bottom).offset(12.0)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    inputField.text = ""
    endEditing(true)
  }
}
