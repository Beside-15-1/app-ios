//
//  TagAndPeriodUnreadFilterView.swift
//  Presentation
//
//  Created by 박천송 on 2/21/24.
//

import Foundation
import UIKit

import SnapKit
import Then

import DesignSystem

protocol TagAndPeriodUnreadFilterViewDelegate: AnyObject {
  func tagAndPeriodUnreadFilterViewSwitchValueChanged(isOn: Bool)
}

final class TagAndPeriodUnreadFilterView: UIView {

  // MARK: UI

  private let titleLabel = UILabel().then {
    $0.attributedText = "읽지 않은 링크만 모아보기".styled(font: .subTitleSemiBold, color: .gray900)
  }

  private let unreadFilteringSwitch = UISwitch().then {
    $0.onTintColor = .naviBtnActive
    $0.isOn = false
  }


  // MARK: Properties

  weak var delegate: TagAndPeriodUnreadFilterViewDelegate?


  // MARK: Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
    addAction()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }


  // MARK: Action

  private func addAction() {
    unreadFilteringSwitch.addAction(UIAction(handler: { [weak self] _ in
      guard let self else { return }
      delegate?.tagAndPeriodUnreadFilterViewSwitchValueChanged(
        isOn: unreadFilteringSwitch.isOn
      )
    }), for: .valueChanged)
  }


  // MARK: Configuring

  func configureFilter(isOn: Bool) {
    unreadFilteringSwitch.isOn = isOn
  }


  // MARK: Layout

  private func defineLayout() {
    [titleLabel, unreadFilteringSwitch].forEach {
      addSubview($0)
    }

    titleLabel.snp.makeConstraints {
      $0.top.bottom.left.equalToSuperview()
    }

    unreadFilteringSwitch.snp.makeConstraints {
      $0.right.equalToSuperview()
      $0.centerX.equalTo(titleLabel)
    }
  }
}
