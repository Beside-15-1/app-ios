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

  var color: UIColor {
    switch self {
    case .primary:
      return .primary
    }
  }

  var pressColor: UIColor {
    switch self {
    case .primary:
      return UIColor(hexString: "#241775")
    }
  }
}

public class BasicButton: UIControl {

  // MARK: Constants

  public static let height: CGFloat = 56.0

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

    flexContainer.flex
      .alignItems(.center)
      .justifyContent(.center)
      .height(BasicButton.height)
      .width(100%)
      .define { flex in
        flex.addItem(titleLabel)
      }
  }

  override public func layoutSubviews() {
    super.layoutSubviews()

    flexContainer.pin.all()
    flexContainer.flex.layout()
  }

  private func enable(isEnabled: Bool) {
    if isEnabled {
      flexContainer.backgroundColor = priority?.color ?? .primary
      titleLabel.textColor = .white
    } else {
      flexContainer.backgroundColor = .gray2
      titleLabel.textColor = .gray3
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
