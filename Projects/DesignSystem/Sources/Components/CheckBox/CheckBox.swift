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

public enum CheckBoxType {
  case fill
  case outline
}

public final class CheckBox: UIControl {

  // MARK: Interfaces

  public override var isSelected: Bool {
    didSet {
      guard isSelected != oldValue else { return }
      if self.type == .fill {
        if isSelected {
          container.backgroundColor = .primary500
        } else {
          container.backgroundColor = .gray400
        }
      } else {
        if isSelected {
          checkIcon.image = checkIcon.image?.withTintColor(.primary500)
        } else {
          checkIcon.image = checkIcon.image?.withTintColor(.gray500)
        }
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
    $0.clipsToBounds = true
  }

  private let checkIcon = UIImageView()

  private var type: CheckBoxType = .outline


  // MARK: Initialize

  public convenience init(type: CheckBoxType) {
    self.init(frame: .zero)
    self.type = type
    if type == .fill {
      container.backgroundColor = .gray400
      checkIcon.image = DesignSystemAsset.iconCheck.image.withTintColor(.staticWhite)
    } else {
      container.backgroundColor = .clear
      checkIcon.image = DesignSystemAsset.iconCheck.image.withTintColor(.gray500)
    }
  }

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
