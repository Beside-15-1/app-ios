//
//  UILabelExtensions.swift
//  DesignSystem
//
//  Created by 박천송 on 2023/05/16.
//

import Foundation
import UIKit

extension String {
  public func underLine(range: [String])-> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: self)

    // ✅ 굵기 1의 언더라인과 함께 처음부터 끝까지 밑줄 설정.
    range.forEach {
      attributedString.addAttribute(.underlineStyle, value: 1, range: (self as NSString).range(of: $0))
    }

    return attributedString
  }
}

extension String {
  public func styled(
    font: UIFont,
    color: UIColor
  )
    -> NSAttributedString {
    let attributedString = NSMutableAttributedString(string: self)

    let attributes: [NSAttributedString.Key: Any] = [
      .font: font,
      .foregroundColor: color,
    ]

    attributedString.addAttributes(
      attributes,
      range: NSRange(location: 0, length: attributedString.length)
    )

    return attributedString
  }
}
