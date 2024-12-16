//
//  LinkDetailBottomButton.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/19.
//

import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem

enum LinkDetailBottomButtonType {
  case delete
  case move
  case edit
}

class LinkDetailBottomButton: UIControl {

  override var isHighlighted: Bool {
    didSet {
      self.runHighlightAnimation()
    }
  }

  // MARK: UI

  private let container = UIView().then {
    $0.isUserInteractionEnabled = false
  }

  private let icon = UIImageView()

  private let text = UILabel()


  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.backgroundColor = .gray100
    self.layer.cornerRadius = 8
    self.clipsToBounds = true

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }


  // MARK: Configuring

  func configure(type: LinkDetailBottomButtonType) {
    switch type {
    case .delete:
      icon.image = DesignSystemAsset.iconTrash.image.withTintColor(.gray900)
      text.attributedText = "삭제".styled(font: .captionRegular, color: .gray900)

    case .move:
      icon.image = DesignSystemAsset.iconFolderTransfer.image.withTintColor(.gray900)
      text.attributedText = "폴더 이동".styled(font: .captionRegular, color: .gray900)

    case .edit:
      icon.image = DesignSystemAsset.iconEdit.image.withTintColor(.gray900)
      text.attributedText = "편집".styled(font: .captionRegular, color: .gray900)
    }
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(container)
    [icon, text].forEach { container.addSubview($0) }

    container.snp.makeConstraints {
      $0.center.equalToSuperview()
    }

    icon.snp.makeConstraints {
      $0.top.left.right.equalToSuperview()
      $0.size.equalTo(24.0)
    }

    text.snp.makeConstraints {
      $0.top.equalTo(icon.snp.bottom).offset(4.0)
      $0.bottom.equalToSuperview()
      $0.centerX.equalToSuperview()
    }
  }


  // MARK: Animation

  private func runHighlightAnimation() {
    UIViewPropertyAnimator.runningPropertyAnimator(
      withDuration: 0.1,
      delay: 0,
      animations: {
        self.backgroundColor = self.isHighlighted ? .gray300 : .gray100
        self.transform = self.isHighlighted ? .init(scaleX: 0.95, y: 0.95) : .identity
      }
    )
  }
}
