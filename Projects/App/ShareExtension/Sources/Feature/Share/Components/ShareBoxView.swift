//
//  ShareBoxView.swift
//  ShareExtension
//
//  Created by 박천송 on 2023/08/21.
//

import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem
import Domain

class ShareBoxView: UIView {

  // MARK: UI

  let container = UIStackView().then {
    $0.axis = .vertical
    $0.distribution = .fill
  }

  let titleView = TitleView().then {
    $0.title = "링크 저장"
  }

  let createLinkSuccessView = CreateLinkSuccessView()

  let titleInputField = InputField(type: .normal).then {
    $0.title = "제목".styled(font: .subTitleSemiBold, color: .staticBlack)
    $0.placeHolder = "제목을 입력해주세요."
    $0.returnKeyType = .done
  }

  let selectFolderButton = SelectFolderButton()

  let buttonStackView = UIStackView().then {
    $0.axis = .horizontal
    $0.distribution = .fillEqually
    $0.spacing = 8
  }

  let addTagButton = BasicButton(priority: .secondary).then {
    $0.text = "태그 추가"
  }

  let completeButton = BasicButton(priority: .primary).then {
    $0.text = "완료"
  }

  let indicator = UIActivityIndicatorView(style: .medium).then {
    $0.isHidden = true
  }


  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .paperWhite
    layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    layer.cornerRadius = 16
    clipsToBounds = true

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }


  // MARK: Configuring

  func configure(status: ShareStatus) {
    switch status {
    case .loading:
      createLinkSuccessView.isHidden = true
      titleInputField.isHidden = true
      buttonStackView.isHidden = true
      selectFolderButton.isHidden = true
      indicator.isHidden = false
      indicator.startAnimating()

    case .success:
      createLinkSuccessView.isHidden = false
      titleInputField.isHidden = false
      selectFolderButton.isHidden = false
      buttonStackView.isHidden = false
      completeButton.text = "완료"
      indicator.isHidden = true
      indicator.stopAnimating()

    case .needLogin:
      createLinkSuccessView.isHidden = false
      buttonStackView.isHidden = false
      completeButton.text = "앱으로 이동"
      addTagButton.isHidden = true
      indicator.isHidden = true
      indicator.stopAnimating()

    case .failure:
      createLinkSuccessView.isHidden = false
      indicator.isHidden = true
      buttonStackView.isHidden = false
      completeButton.text = "다시 시도"
      addTagButton.isHidden = true
      indicator.isHidden = true
      indicator.stopAnimating()
    }

    createLinkSuccessView.configure(status: status)
  }

  func configure(link: Link?) {
    titleInputField.do {
      $0.text = link?.title
    }

    selectFolderButton.configure(withFolder: link?.folderName ?? "기본")
  }


  // MARK: Layout

  private func defineLayout() {
    self.snp.makeConstraints {
      $0.height.greaterThanOrEqualTo(300.0)
    }

    [titleView, container, indicator].forEach {
      addSubview($0)
    }

    [createLinkSuccessView, titleInputField, selectFolderButton, buttonStackView].forEach {
      container.addArrangedSubview($0)
    }
    [addTagButton, completeButton].forEach {
      buttonStackView.addArrangedSubview($0)
    }

    titleView.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
    }

    container.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(20.0)
      $0.top.equalTo(titleView.snp.bottom).offset(12.0)
      $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(20.0)
    }

    container.setCustomSpacing(16.0, after: createLinkSuccessView)
    container.setCustomSpacing(20.0, after: titleInputField)
    container.setCustomSpacing(20.0, after: selectFolderButton)

    indicator.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
}
