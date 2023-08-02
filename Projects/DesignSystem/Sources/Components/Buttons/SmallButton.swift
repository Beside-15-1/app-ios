//
//  SmallButton.swift
//  DesignSystem
//
//  Created by 박천송 on 2023/07/07.
//

import Foundation
import UIKit

public class SmallButton: UIControl {

  // MARK: Constants

  private enum Metric {
    static let buttonHeight: CGFloat = 38.0
  }

  // MARK: Properties

  public var text: String? {
    didSet {
      guard text != oldValue else { return }
      titleLabel.attributedText = text?.styled(font: .bodyBold, color: .white)
    }
  }

  public override var isEnabled: Bool {
    didSet {
      guard isEnabled != oldValue else { return }
      enable(isEnabled: isEnabled)
    }
  }

  public var icon: UIImage? {
    didSet {
      imageView.image = icon?.withTintColor(.white)
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

  private let container = UIView()

  private let imageView = UIImageView()

  private let titleLabel = UILabel()

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
    [container].forEach { flexContainer.addSubview($0) }
    [imageView, titleLabel].forEach { container.addSubview($0) }

    flexContainer.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.height.equalTo(Metric.buttonHeight)
    }

    container.snp.makeConstraints {
      $0.center.equalToSuperview()
    }

    imageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.size.equalTo(24.0)
      $0.left.equalToSuperview()
      $0.right.equalTo(titleLabel.snp.left).offset(-4.0)
    }

    titleLabel.snp.makeConstraints {
      $0.top.bottom.right.equalToSuperview()
    }
  }

  private func enable(isEnabled: Bool) {
    if isEnabled {
      flexContainer.backgroundColor = priority?.color ?? .primary500
      titleLabel.textColor = .white
      imageView.image = imageView.image?.withTintColor(.white)
    } else {
      flexContainer.backgroundColor = .gray300
      titleLabel.textColor = .gray500
      imageView.image = imageView.image?.withTintColor(.gray500)
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
