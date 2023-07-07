//
//  UIColorExtensions.swift
//  DesignSystem
//
//  Created by 박천송 on 2023/05/15.
//

import UIKit

public extension UIColor {
  convenience init(hexString: String, alpha: CGFloat = 1.0) {
    var formattedHexString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
    formattedHexString = formattedHexString.replacingOccurrences(of: "#", with: "")

    let scanner = Scanner(string: formattedHexString)
    var hexValue: UInt64 = 0

    let scanResult = scanner.scanHexInt64(&hexValue)

    assert(scanResult, "잘못된 Hex값이 입력됐습니다.")

    let red = CGFloat((hexValue & 0xff0000) >> 16) / 255.0
    let green = CGFloat((hexValue & 0x00ff00) >> 8) / 255.0
    let blue = CGFloat(hexValue & 0x0000ff) / 255.0

    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }

  convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) {
    let red = r / 255.0
    let green = g / 255.0
    let blue = b / 255.0

    self.init(red: red, green: green, blue: blue, alpha: a)
  }
}
