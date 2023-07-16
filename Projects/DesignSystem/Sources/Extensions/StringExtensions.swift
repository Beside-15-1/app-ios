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

      let style = NSMutableParagraphStyle()
      style.lineBreakMode = .byTruncatingTail

      switch font {
      case .accentTitle:
        style.minimumLineHeight = 28
      case .titleBold, .titleRegular, .titleSemiBold, .titleExtraBold:
        style.minimumLineHeight = 20
      case .subTitleBold, .subTitleRegular, .subTitleSemiBold:
        style.minimumLineHeight = 18
      case .defaultBold, .defaultRegular, .defaultSemiBold, .defaultExtraBold:
        style.minimumLineHeight = 16
      case .bodyBold, .bodyRegular, .bodySemiBold:
        style.minimumLineHeight = 14
      case .captionRegular, .captionSemiBold:
        style.minimumLineHeight = 12
      default:
        break
      }

    let attributedString = NSMutableAttributedString(string: self)

    let attributes: [NSAttributedString.Key: Any] = [
      .font: font,
      .foregroundColor: color,
      .paragraphStyle: style
    ]

    attributedString.addAttributes(
      attributes,
      range: NSRange(location: 0, length: attributedString.length)
    )

    return attributedString
  }
}


extension NSAttributedString {

  public func changeTarget(font: UIFont, target: String) -> NSAttributedString {

    let attributedString = NSMutableAttributedString(attributedString: self)

    let range = (self.string as NSString).range(of: target)

    attributedString.addAttributes([
      .font: font
    ], range: range)

    return attributedString
  }
}
