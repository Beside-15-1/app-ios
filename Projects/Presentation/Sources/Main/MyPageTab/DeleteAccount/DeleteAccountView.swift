//
//  DeleteAccountView.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/22.
//

import UIKit

import SnapKit
import Then

import DesignSystem

final class DeleteAccountView: UIView {

  let imageView = UIImageView().then {
    $0.image = DesignSystemAsset.imgOut.image.withTintColor(.staticBlack)
  }

  let titleLabel = UILabel().then {
    $0.attributedText = "탈퇴 시 아래 데이터가 모두 삭제됩니다.".styled(font: .subTitleSemiBold, color: .gray900)
    $0.numberOfLines = 0
  }

  let infoContainer = UIView().then {
    $0.backgroundColor = .gray200
    $0.layer.cornerRadius = 16
    $0.clipsToBounds = true
  }

  let infoLabel = UILabel().then {
    $0.attributedText = "저장된 링크 / 폴더와 태그 / 계정정보".styled(font: .subTitleRegular, color: .gray900)
    $0.numberOfLines = 0
  }

  let descriptionLabel = UILabel().then {
    $0.attributedText = "같은 계정으로 재가입은\n탈퇴 후 30일이 지나야 가능합니다.\n재가입 시 저장했던 링크, 폴더, 태그는\n복구되지 않습니다."
      .styled(font: .subTitleRegular, color: .gray900)
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }

  let askLabel = UILabel().then {
    $0.attributedText = "정말 계정을 탈퇴하시겠어요?".styled(font: .subTitleSemiBold, color: .gray900)
    $0.numberOfLines = 0
  }

  let checkContainer = UIView()

  let checkBox = CheckBox(type: .fill)

  let checkLabel = UILabel().then {
    $0.attributedText = "위 안내사항을 확인하였으며 이에 동의합니다.".styled(font: .bodyRegular, color: .gray800)
    $0.numberOfLines = 0
  }

  let deleteButton = BasicButton(priority: .primary).then {
    $0.text = "탈퇴하기"
  }

  let useButton = BasicButton(priority: .primary).then {
    $0.text = "주섬 계속 이용하기"
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
    [
      imageView,
      titleLabel,
      infoContainer,
      descriptionLabel,
      askLabel,
      checkContainer,
      deleteButton,
      useButton,
    ]
    .forEach { addSubview($0) }

    infoContainer.addSubview(infoLabel)
    checkContainer.addSubview(checkBox)
    checkContainer.addSubview(checkLabel)

    imageView.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide).inset(49.0)
      $0.centerX.equalToSuperview()
      $0.width.equalTo(193)
      $0.height.equalTo(108)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(imageView.snp.bottom).offset(12)
      $0.centerX.equalToSuperview()
    }

    infoContainer.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(12)
      $0.centerX.equalToSuperview()
    }

    infoLabel.snp.makeConstraints {
      $0.left.right.equalToSuperview().inset(20.0)
      $0.top.bottom.equalToSuperview().inset(12.0)
    }

    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(infoContainer.snp.bottom).offset(16.0)
      $0.centerX.equalToSuperview()
    }

    askLabel.snp.makeConstraints {
      $0.top.equalTo(descriptionLabel.snp.bottom).offset(16.0)
      $0.centerX.equalToSuperview()
    }

    checkContainer.snp.makeConstraints {
      $0.top.equalTo(askLabel.snp.bottom).offset(46.0)
      $0.centerX.equalToSuperview()
    }

    checkLabel.snp.makeConstraints {
      $0.top.bottom.right.equalToSuperview()
      $0.left.equalTo(checkBox.snp.right).offset(4.0)
    }

    checkBox.snp.makeConstraints {
      $0.left.equalToSuperview()
      $0.centerY.equalTo(checkLabel)
    }

    deleteButton.snp.makeConstraints {
      $0.width.equalTo(132.0)
      $0.top.equalTo(checkContainer.snp.bottom).offset(20.0)
      $0.centerX.equalToSuperview()
    }

    useButton.snp.makeConstraints {
      $0.left.bottom.right.equalTo(safeAreaLayoutGuide).inset(20.0)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
