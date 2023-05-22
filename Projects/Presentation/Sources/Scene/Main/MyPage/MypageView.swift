//
//  MyPageView.swift
//  Presentation
//
//  Created by 박천송 on 2023/05/19.
//

import UIKit

import FlexLayout
import PinLayout
import SnapKit
import Then

final class MyPageView: UIView {
  // TODO: 테스트용
  let testButton = UIButton().then {
    $0.setTitle("LOGOUT", for: .normal)
    $0.setTitleColor(.black, for: .normal)
  }

  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .gray1

    addSubview(testButton)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()
    testButton.pin.center().sizeToFit()
  }
}
