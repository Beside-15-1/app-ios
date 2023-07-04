//
//  TextButton.swift
//  DesignSystem
//
//  Created by 박천송 on 2023/06/05.
//

import Foundation
import UIKit

import SnapKit
import Then

public enum TextButtonType {
  case regular
  case small

  var font: UIFont? {
    switch self {
    case .regular:
      return .defaultSemiBold
    case .small:
      return .captionSemiBold
    }
  }

  var iconSize: CGSize {
    switch self {
    case .regular:
      return CGSize(width: 24.0, height: 24.0)
    case .small:
      return CGSize(width: 16.0, height: 16.0)
    }
  }
}

public class TextButton: UIControl {

  public var leftIconImage: UIImage? {
    didSet {
      guard let leftIconImage else {
        return
      }

      leftIcon.image = leftIconImage.withTintColor(.textButtonColor).withTintColor(color)
      leftIcon.snp.updateConstraints {
        $0.size.equalTo(type.iconSize)
      }
    }
  }

  public var rightIconImage: UIImage? {
    didSet {
      guard let rightIconImage else {
        return
      }

      rightIcon.image = rightIconImage.withTintColor(.textButtonColor).withTintColor(color)
      rightIcon.snp.updateConstraints {
        $0.size.equalTo(type.iconSize)
      }
    }
  }

  public var text: String? {
    didSet {
      guard text != oldValue else { return }
      titleLabel.text = text
      titleLabel.textColor = color
    }
  }

  // MARK: UI

  private let container = UIView().then {
    $0.backgroundColor = .clear
    $0.isUserInteractionEnabled = false
  }

  private let titleLabel = UILabel().then {
    $0.textColor = .textButtonColor
    $0.font = .defaultSemiBold
  }

  private let leftIcon = UIImageView()
  private let rightIcon = UIImageView()


  // MARK: Properties

  private var type: TextButtonType = .regular
  private var color: UIColor = .gray700


  // MARK: Initialize

  public convenience init(type: TextButtonType, color: UIColor = .gray700) {
    self.init(frame: .zero)
    self.type = type
    self.color = color

    titleLabel.font = type.font
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  private func defineLayout() {
    addSubview(container)

    [leftIcon, titleLabel, rightIcon].forEach { container.addSubview($0) }

    container.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    titleLabel.snp.makeConstraints {
      $0.top.bottom.equalToSuperview()
    }

    leftIcon.snp.makeConstraints {
      $0.left.centerY.equalToSuperview()
      $0.right.equalTo(titleLabel.snp.left)
      $0.size.equalTo(0)
    }

    rightIcon.snp.makeConstraints {
      $0.right.centerY.equalToSuperview()
      $0.left.equalTo(titleLabel.snp.right)
      $0.size.equalTo(0)
    }

  }
}
