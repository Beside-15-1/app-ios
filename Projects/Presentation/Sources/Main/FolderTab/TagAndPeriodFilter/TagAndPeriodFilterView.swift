//
//  TagAndPeriodFilterView.swift
//  Presentation
//
//  Created by 박천송 on 12/20/23.
//

import UIKit

import SnapKit
import Then

import DesignSystem

protocol TagAndPeriodFilterViewDelegate: AnyObject {
  func tagAndPeriodFilterViewCloseButtonTapped()
}

final class TagAndPeriodFilterView: UIView {

  // MARK: UI

  private let titleView = TitleView().then {
    $0.title = "필터"
  }
  // MARK: Properties

  weak var delegate: TagAndPeriodFilterViewDelegate?


  // MARK: Initializing

  override init(frame: CGRect) {
    super.init(frame: frame)

    backgroundColor = .paperWhite

    defineLayout()

    titleView.onCloseAction = { [weak self] in
      self?.delegate?.tagAndPeriodFilterViewCloseButtonTapped()
    }
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()
  }
}
