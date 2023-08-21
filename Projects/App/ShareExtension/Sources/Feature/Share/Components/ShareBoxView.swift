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

  let titleView = TitleView().then {
    $0.title = "링크 저장"
  }

  let createLinkSuccessView = CreateLinkSuccessView()

  let titleInputField = InputField(type: .normal).then {
    $0.title = "제목".styled(font: .subTitleSemiBold, color: .staticBlack)
    $0.placeHolder = "제목을 입력해주세요."
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
      completeButton.isHidden = true
      indicator.isHidden = false
      indicator.startAnimating()

    case .success:
      createLinkSuccessView.isHidden = false
      titleInputField.isHidden = false
      completeButton.isHidden = false
      indicator.isHidden = true
      indicator.startAnimating()

    case .needLogin:
      createLinkSuccessView.isHidden = false
      completeButton.isHidden = false
      completeButton.text = "앱으로 이동"
      indicator.isHidden = true
      indicator.startAnimating()

    case .failure:
      indicator.isHidden = true
      indicator.startAnimating()
    }

    createLinkSuccessView.configure(status: status)
  }

  func configure(link: Link?) {
    titleInputField.do {
      $0.text = link?.title
    }
  }


  // MARK: Layout

  private func defineLayout() {
    [titleView, createLinkSuccessView, titleInputField, completeButton, indicator].forEach {
      addSubview($0)
    }

    titleView.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
    }

    createLinkSuccessView.snp.makeConstraints {
      $0.top.equalTo(titleView.snp.bottom).offset(12.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    titleInputField.snp.makeConstraints {
      $0.top.equalTo(createLinkSuccessView.snp.bottom).offset(16.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    completeButton.snp.makeConstraints {
      $0.top.equalTo(titleInputField.snp.bottom).offset(20.0)
      $0.left.right.equalToSuperview().inset(20.0)
      $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(20.0)
    }

    indicator.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
}
