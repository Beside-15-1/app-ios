//
//  NotificationSettingView.swift
//  Presentation
//
//  Created by 박천송 on 10/24/23.
//

import UIKit

import SnapKit
import Then

import DesignSystem

final class NotificationSettingView: UIView {

  private let stackView = UIStackView().then {
    $0.distribution = .fill
    $0.axis = .vertical
    $0.spacing = 1
    $0.backgroundColor = .gray400
  }

  let unreadItem = NotificationSettingItemView().then {
    $0.configure(type: .unread)
  }

  let unclassifyItem = NotificationSettingItemView().then {
    $0.configure(type: .unclassify)
  }

  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .paperWhite

    defineLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(stackView)
    [unreadItem, unclassifyItem].forEach { stackView.addArrangedSubview($0) }

    stackView.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide).inset(16.0)
      $0.left.right.equalToSuperview().inset(20.0)
    }
  }

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
