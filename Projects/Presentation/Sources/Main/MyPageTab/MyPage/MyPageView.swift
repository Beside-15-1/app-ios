//
//  MyPageView.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/20.
//

import UIKit

import SnapKit
import Then

import DesignSystem

final class MyPageView: UIView {

  private let titleLabel = UILabel().then {
    $0.attributedText = "내 정보".styled(font: .titleBold, color: .white)
  }

  private let colorBackground = UIView().then {
    $0.backgroundColor = .paperAboveBg
  }

  private let scrollView = UIScrollView().then {
    $0.showsVerticalScrollIndicator = false
  }

  private let settingStackView = UIStackView().then {
    $0.axis = .vertical
    $0.distribution = .equalSpacing
    $0.backgroundColor = .gray400
    $0.spacing = 1
  }

  private let settingHeaderView = MyPageHeaderView().then {
    $0.configureTitle(title: "설정")
  }

  let tagButton = MyPageItemButton().then {
    $0.configure(type: .tag)
  }

  let themeButton = MyPageItemButton().then {
    $0.configure(type: .theme)
  }

  private let accountStackView = UIStackView().then {
    $0.axis = .vertical
    $0.distribution = .equalSpacing
    $0.backgroundColor = .gray400
    $0.spacing = 1
  }

  private let accountHeaderView = MyPageHeaderView().then {
    $0.configureTitle(title: "내 계정")
  }

  let accountButton = MyPageItemButton().then {
    $0.configure(type: .sign)
  }

  let appInfoStackView = UIStackView().then {
    $0.axis = .vertical
    $0.distribution = .equalSpacing
    $0.backgroundColor = .gray400
    $0.spacing = 1
  }

  private let appInfoHeaderView = MyPageHeaderView().then {
    $0.configureTitle(title: "앱 정보")
  }

  let serviceButton = MyPageItemButton().then {
    $0.configure(type: .service)
  }

  let securityButton = MyPageItemButton().then {
    $0.configure(type: .security)
  }

  let versionButton = MyPageItemButton().then {
    $0.configure(type: .version)
  }

  let logoutButton = MyPageItemButton().then {
    $0.configure(type: .logout)
  }

  let deleteAccountButton = UIControl()
  let deleteAccountLabel = UILabel().then {
    $0.attributedText = "회원탈퇴"
      .styled(font: .bodyRegular, color: .gray700)
      .underLine(target: "회원탈퇴")
  }


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .staticWhite

    defineLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Layout

  private func defineLayout() {
    [colorBackground, titleLabel, scrollView].forEach {
      addSubview($0)
    }

    [settingHeaderView, settingStackView, accountHeaderView, accountStackView, appInfoHeaderView, appInfoStackView, deleteAccountButton]
      .forEach { scrollView.addSubview($0) }

    [tagButton, themeButton].forEach { settingStackView.addArrangedSubview($0) }
    [accountButton].forEach { accountStackView.addArrangedSubview($0) }
    [serviceButton, securityButton, versionButton, logoutButton]
      .forEach { appInfoStackView.addArrangedSubview($0) }
    deleteAccountButton.addSubview(deleteAccountLabel)

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide).inset(40.0)
      $0.left.equalToSuperview().inset(20.0)
    }

    colorBackground.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
      $0.bottom.equalTo(titleLabel.snp.bottom).offset(40.0)
    }

    scrollView.snp.makeConstraints {
      $0.left.right.equalToSuperview()
      $0.width.equalToSuperview()
      $0.bottom.equalTo(safeAreaLayoutGuide)
      $0.top.equalTo(colorBackground.snp.bottom)
    }

    settingHeaderView.snp.makeConstraints {
      $0.left.right.top.equalToSuperview()
      $0.width.equalToSuperview()
    }

    settingStackView.snp.makeConstraints {
      $0.top.equalTo(settingHeaderView.snp.bottom)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    accountHeaderView.snp.makeConstraints {
      $0.top.equalTo(settingStackView.snp.bottom)
      $0.left.right.equalToSuperview()
      $0.width.equalToSuperview()
    }

    accountStackView.snp.makeConstraints {
      $0.top.equalTo(accountHeaderView.snp.bottom)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    appInfoHeaderView.snp.makeConstraints {
      $0.top.equalTo(accountStackView.snp.bottom)
      $0.left.right.equalToSuperview()
      $0.width.equalToSuperview()
    }

    appInfoStackView.snp.makeConstraints {
      $0.top.equalTo(appInfoHeaderView.snp.bottom)
      $0.left.right.equalToSuperview().inset(20.0)
    }

    deleteAccountButton.snp.makeConstraints {
      $0.top.equalTo(appInfoStackView.snp.bottom).offset(20.0)
      $0.left.equalToSuperview().inset(20.0)
      $0.bottom.equalToSuperview().inset(40.0)
    }

    deleteAccountLabel.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
