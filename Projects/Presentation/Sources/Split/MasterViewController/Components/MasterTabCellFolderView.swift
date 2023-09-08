//
//  MasterTabCellFolderView.swift
//  Presentation
//
//  Created by 박천송 on 2023/09/06.
//

import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem

class MasterTabCellFolderView: UIView {

  struct ViewModel: Hashable {
    let id: String
    let color: String
    let title: String
  }


  // MARK: Constant

  private enum Metric {
    static let colorIcon = CGSize(width: 20.0, height: 20.0)
  }


  // MARK: UI

  private let colorIcon = UIView().then {
    $0.layer.cornerRadius = Metric.colorIcon.height / 2
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.white.cgColor
  }

  private let titleLabel = UILabel()


  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  // MARK: Configuring

  func configure(viewModel: ViewModel) {
    colorIcon.backgroundColor = UIColor(hexString: viewModel.color)

    titleLabel.attributedText = viewModel.title.styled(font: .defaultBold, color: .gray800)
  }


  // MARK: Layout

  private func defineLayout() {
    [colorIcon, titleLabel].forEach { addSubview($0) }

    colorIcon.snp.makeConstraints {
      $0.left.equalToSuperview().inset(30.0)
      $0.centerY.equalToSuperview()
      $0.size.equalTo(20.0)
    }

    titleLabel.snp.makeConstraints {
      $0.left.equalTo(colorIcon.snp.right).offset(8.0)
      $0.centerY.equalToSuperview()
      $0.right.equalToSuperview().inset(30.0)
    }
  }
}

