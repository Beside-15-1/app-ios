//
//  EditFolderDeleteButton.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/14.
//

import UIKit

import SnapKit
import Then

import DesignSystem

final class EditFolderDeleteButton: UIControl {

  // MARK: UI

  private let titleLabel = UILabel().then {
    $0.attributedText = "폴더 삭제".styled(font: .defaultSemiBold, color: .staticBlack)
  }


  // MARK: Properties

  override var isHighlighted: Bool {
    didSet {
      runHighlightAnimation()
    }
  }


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .clear
    transform = .identity
    clipsToBounds = true
    layer.cornerRadius = 8.0

    defineLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(titleLabel)

    self.snp.makeConstraints {
      $0.height.equalTo(48.0)
    }

    titleLabel.snp.makeConstraints {
      $0.left.equalToSuperview().inset(24.0)
      $0.centerY.equalToSuperview()
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }


  // MARK: Animation

  private func runHighlightAnimation() {
    UIViewPropertyAnimator.runningPropertyAnimator(
      withDuration: 0.1,
      delay: 0,
      animations: {
        self.backgroundColor = self.isHighlighted ? .gray100 : .gray100
        self.transform = self.isHighlighted ? .init(scaleX: 0.95, y: 0.95) : .identity
      }
    )
  }
}
