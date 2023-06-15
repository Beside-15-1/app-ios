//
//  CheckBox.swift
//  DesignSystem
//
//  Created by 박천송 on 2023/06/15.
//

import Foundation
import UIKit

import SnapKit
import Then

public final class CheckBox: UIControl {

  // MARK: Interfaces

  public override var isSelected: Bool {
    didSet {
      guard isSelected != oldValue else { return }
      if isSelected {
        container.backgroundColor = .primary500
      } else {
        container.backgroundColor = .gray400
      }
    }
  }

  // MARK: Constants

  private enum Metric {
    static let checkBoxSize = CGSize(width: 24.0, height: 24.0)
  }


  // MARK: UI

  private let container = UIView().then {
    $0.isUserInteractionEnabled = false
    $0.layer.cornerRadius = Metric.checkBoxSize.height / 2
    $0.backgroundColor = .gray400
    $0.clipsToBounds = true
  }

  private let checkIcon = UIImageView().then {
    $0.image = DesignSystemAsset.iconCheck.image.withTintColor(.staticWhite)
  }


  // MARK: Initialize

  public override init(frame: CGRect) {
    super.init(frame: frame)
    defineLayout()
    addAction()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
  }


  // MARK: AddAction

  private func addAction() {
    addAction(UIAction(handler: { [weak self] _ in
      guard let self else { return }
      self.isSelected.toggle()
    }), for: .touchUpInside)
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(container)
    addSubview(checkIcon)

    container.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.size.equalTo(Metric.checkBoxSize)
    }

    checkIcon.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.size.equalTo(Metric.checkBoxSize)
    }
  }
}
