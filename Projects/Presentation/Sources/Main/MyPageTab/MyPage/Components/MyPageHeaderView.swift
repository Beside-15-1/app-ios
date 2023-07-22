//
//  MyPageHeaderView.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/20.
//

import UIKit

import SnapKit
import Then

import DesignSystem

final class MyPageHeaderView: UIView {

  // MARK: UI

  private let titleLabel = UILabel()

  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.backgroundColor = .gray200

    defineLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  func configureTitle(title: String) {
    titleLabel.attributedText = title.styled(font: .bodyBold, color: .gray700)
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(titleLabel)

    self.snp.makeConstraints {
      $0.height.equalTo(38.0)
    }

    titleLabel.snp.makeConstraints {
      $0.left.equalToSuperview().inset(20.0)
      $0.centerY.equalToSuperview()
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
