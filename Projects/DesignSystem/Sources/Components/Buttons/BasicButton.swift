//
//  BasicButton.swift
//  DesignSystem
//
//  Created by 박천송 on 2023/06/01.
//

import Foundation
import UIKit

import FlexLayout
import PinLayout
import Then
import SnapKit

public enum ButtonPriority {
  case primary
  case secondary

  var color: UIColor {
    switch self {
    case .primary:
      return .primary500

    case .secondary:
      return .gray500
    }
  }

  var pressColor: UIColor {
    switch self {
    case .primary:
      return .basicButtonPressedColor

    case .secondary:
      return .gray600
    }
  }
}

public class BasicButton: UIControl {

  // MARK: Constants

  private enum Metric {
    static let buttonHeight: CGFloat = 56.0
  }

  // MARK: Properties

  public var text: String? {
    didSet {
      guard text != oldValue else { return }
      titleLabel.text = text
    }
  }

  public override var isEnabled: Bool {
    didSet {
      guard isEnabled != oldValue else { return }
      enable(isEnabled: isEnabled)
    }
  }

  public func toggle() {
    isSelected.toggle()
  }

  private var priority: ButtonPriority?

  // MARK: UI

  private let flexContainer = UIView().then {
    $0.isUserInteractionEnabled = false
    $0.layer.cornerRadius = 8
    $0.clipsToBounds = true
  }

  private let titleLabel = UILabel().then {
    $0.font = .defaultBold
    $0.textColor = .white
  }

  // MARK: Initialize

  public convenience init(priority: ButtonPriority) {
    self.init(frame: .zero)

    self.priority = priority
    flexContainer.backgroundColor = priority.color
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
    accessibilityTraits = .button
    accessibilityLabel = titleLabel.text
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(flexContainer)
    [titleLabel].forEach { flexContainer.addSubview($0) }

    flexContainer.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.height.equalTo(Metric.buttonHeight)
    }

    titleLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }

  private func enable(isEnabled: Bool) {
    if isEnabled {
      flexContainer.backgroundColor = priority?.color ?? .primary500
      titleLabel.textColor = .white
    } else {
      flexContainer.backgroundColor = .gray300
      titleLabel.textColor = .gray500
    }
  }

  public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    flexContainer.backgroundColor = priority?.pressColor
  }

  public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    flexContainer.backgroundColor = priority?.color
  }
}
