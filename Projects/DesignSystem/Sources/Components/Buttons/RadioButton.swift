//
//  RadioButton.swift
//  DesignSystem
//
//  Created by 박천송 on 2023/09/18.
//

import Foundation
import UIKit

import SnapKit
import Then

public enum RadioButtonType {
  case fill
  case outline
}

public class RadioButton: UIControl {

  // MARK: UI

  private let container = UIView()


  // MARK: Properties

  private var type: RadioButtonType?

  private var outCircleLayer = CAShapeLayer()
  private var innerCircleLayer = CAShapeLayer()

  public override var isSelected: Bool {
    didSet {
      setNeedsDisplay()
    }
  }


  // MARK: Initialize

  public convenience init(type: RadioButtonType) {
    self.init(frame: .zero)
    self.type = type
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)

    defineLayout()
    addAction()
  }

  public required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  override public func draw(_ rect: CGRect) {
    guard let type else { return }
    drawLayer(type: type)
  }


  // MARK: Action

  private func addAction() {
    addAction(UIAction(handler: { [weak self] _ in
      guard let self else { return }
      self.isSelected.toggle()
    }), for: .touchUpInside)
  }


  // MARK: Layout

  private func defineLayout() {
    addSubview(container)

    container.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  private func drawLayer(type: RadioButtonType) {
    let outCirclePath: UIBezierPath
    let innerCirclePath: UIBezierPath

    if type == .fill {
      outCirclePath = UIBezierPath(
        arcCenter: center,
        radius: 12,
        startAngle: 0,
        endAngle: CGFloat(2 * Double.pi),
        clockwise: true
      )

      outCircleLayer.path = outCirclePath.cgPath
      outCircleLayer.lineWidth = 5.0
      outCircleLayer.fillColor = UIColor.clear.cgColor

      innerCirclePath = UIBezierPath(
        arcCenter: center,
        radius: 7,
        startAngle: 0,
        endAngle: CGFloat(2 * Double.pi),
        clockwise: true
      )

      innerCircleLayer.path = innerCirclePath.cgPath

      if isSelected {
        outCircleLayer.strokeColor = UIColor(hexString: "#D8D5ED").cgColor
        innerCircleLayer.fillColor = UIColor.primary400.cgColor
      } else {
        outCircleLayer.strokeColor = UIColor.gray400.cgColor
        innerCircleLayer.fillColor = UIColor.white.cgColor
      }

      container.layer.addSublayer(outCircleLayer)
      container.layer.addSublayer(innerCircleLayer)
    } else {
      outCirclePath = UIBezierPath(
        arcCenter: center,
        radius: 12.0,
        startAngle: 0,
        endAngle: CGFloat(2 * Double.pi),
        clockwise: true
      )

      outCircleLayer.path = outCirclePath.cgPath
      outCircleLayer.lineWidth = 2.0
      outCircleLayer.fillColor = UIColor.clear.cgColor

      innerCirclePath = UIBezierPath(
        arcCenter: center,
        radius: 6.0,
        startAngle: 0,
        endAngle: CGFloat(2 * Double.pi),
        clockwise: true
      )

      innerCircleLayer.path = innerCirclePath.cgPath

      if isSelected {
        outCircleLayer.strokeColor = UIColor(hexString: "#BA75FF").cgColor
        innerCircleLayer.fillColor = UIColor(hexString: "#BA75FF").cgColor
      } else {
        outCircleLayer.strokeColor = UIColor.gray500.cgColor
        innerCircleLayer.fillColor = UIColor.gray500.cgColor
      }

      container.layer.addSublayer(outCircleLayer)
      container.layer.addSublayer(innerCircleLayer)
    }
  }
}
