//
//  FAB.swift
//  DesignSystem
//
//  Created by 박천송 on 2023/06/10.
//

import Foundation
import UIKit

import SnapKit
import Then

public final class FAB: UIControl {

  // MARK: Contants

  private enum Metric {
    static let plusIcon = CGSize(width: 28.0, height: 28.0)
    static let stackViewHeight: CGFloat = 28.0
    static let containerHeight: CGFloat = 58.0
  }


  // MARK: UI

  private let container = UIView().then {
    $0.backgroundColor = .primary400
    $0.layer.cornerRadius = Metric.containerHeight / 2
    $0.clipsToBounds = true
    $0.isUserInteractionEnabled = false
  }

  private let stackView = UIStackView().then {
    $0.axis = .horizontal
  }

  private let plusIcon = UIImageView().then {
    $0.image = DesignSystemAsset.iconPlus.image.withTintColor(.fabTextColor)
  }

  private let linkLabel = UILabel().then {
    $0.text = "링크"
    $0.font = .subTitleSemiBold
    $0.textColor = .fabTextColor
  }


  // MARK: Properties

  private var isExpand = true


  // MARK: Initialize

  public override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  public func expand() {
    guard !isExpand else { return }

    UIViewPropertyAnimator.runningPropertyAnimator(
      withDuration: 0.2,
      delay: 0,
      animations: {
        self.linkLabel.alpha = 1.0
        self.linkLabel.isHidden = false
        self.layoutIfNeeded()
      },
      completion: { _ in
        self.isExpand = true
      }
    )
  }

  public func contract() {
    guard isExpand else { return }

    linkLabel.alpha = 0.0

    UIViewPropertyAnimator.runningPropertyAnimator(
      withDuration: 0.2,
      delay: 0,
      animations: {
        self.linkLabel.isHidden = true
        self.layoutIfNeeded()
      },
      completion: { _ in
        self.isExpand = false
      }
    )
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(container)
    container.addSubview(stackView)
    [plusIcon, linkLabel].forEach { stackView.addArrangedSubview($0) }

    container.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    stackView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(15.0)
      $0.left.right.equalToSuperview().inset(16.0)
      $0.height.equalTo(Metric.stackViewHeight)
    }

    plusIcon.snp.makeConstraints {
      $0.size.equalTo(Metric.plusIcon)
    }

    linkLabel.snp.makeConstraints {
      $0.width.equalTo(40.0)
    }
  }
}
