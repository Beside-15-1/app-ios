//
//  HomeFeedTagView.swift
//  Presentation
//
//  Created by 박천송 on 6/25/24.
//

import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem

final class HomeFeedTagView: UIView {

  // MARK: UI

  private let stackView = UIStackView().then {
    $0.axis = .horizontal
    $0.alignment = .leading
    $0.distribution = .equalSpacing
    $0.spacing = 8.0
  }


  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.backgroundColor = .paperCard

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(stackView)

    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  func configureTags(tags: [String]) {
    tags.forEach { tag in
      let container = UIView().then {
        $0.layer.cornerRadius = 14.0
        $0.backgroundColor = .gray300
        $0.clipsToBounds = true
      }

      let label = UILabel().then {
        $0.attributedText = tag.styled(font: .captionRegular, color: .staticBlack)
        $0.textAlignment = .center
      }

      container.addSubview(label)
      label.snp.makeConstraints {
        $0.center.equalToSuperview()
        $0.top.bottom.equalTo(4.0)
        $0.left.right.equalTo(8.0)
      }

      stackView.addArrangedSubview(container)
    }
  }
}
