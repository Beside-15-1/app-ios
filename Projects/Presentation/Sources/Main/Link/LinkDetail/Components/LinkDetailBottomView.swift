//
//  LinkDetailBottomView.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/19.
//

import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem

class LinkDetailBottomView: UIView {

  // MARK: UI

  private let stackView = UIStackView().then {
    $0.axis = .horizontal
    $0.distribution = .fillEqually
  }

  let deleteButton = LinkDetailBottomButton().then {
    $0.configure(type: .delete)
  }

  let moveButton = LinkDetailBottomButton().then {
    $0.configure(type: .move)
  }

  let editButton = LinkDetailBottomButton().then {
    $0.configure(type: .edit)
  }

  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    self.backgroundColor = .gray100

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(stackView)
    [deleteButton, moveButton, editButton].forEach { stackView.addArrangedSubview($0) }

    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.height.equalTo(82)
    }
  }
}
