//
//  Color.swift
//  DesignSystem
//
//  Created by 박천송 on 2023/05/15.
//

import UIKit

public extension UIColor {

  // MARK: Primary

  /// static: #EFECFF
  static let primary100 = UIColor(hexString: "#EFECFF")
  /// static: #DFD9FF
  static let primary200 = UIColor(hexString: "#DFD9FF")
  /// static: #A299F6
  static let primary300 = UIColor(hexString: "#A299F6")

  /// light: #6B5FDE / dark: #DFD9FF
  static let primary400 = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return UIColor(hexString: "#DFD9FF")
    } else {
      return UIColor(hexString: "#6B5FDE")
    }
  }

  /// light: #6B5FDE / dark: #392A95
  static let primary500 = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return UIColor(hexString: "#6B5FDE")
    } else {
      return UIColor(hexString: "#392A95")
    }
  }

  /// static: #2E2277
  static let primary600 = UIColor(hexString: "#2E2277")

  /// static: #221959
  static let primary700 = UIColor(hexString: "#221959")

  /// static: #17113C
  static let primary800 = UIColor(hexString: "#17113C")

  /// static: #0B081E
  static let primary900 = UIColor(hexString: "#0B081E")

  /// #7B63A4
  static let secondary1 = UIColor(hexString: "#7B63A4")
  /// #CBC7D8
  static let secondary2 = UIColor(hexString: "#CBC7D8")
  /// #F2B2AC"
  static let secondary3 = UIColor(hexString: "#F2B2AC")
  /// #FDEFE8
  static let secondary4 = UIColor(hexString: "#FDEFE8")


  // MARK: Gray

  /// light: white / dark: black
  static let staticWhite = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return .black
    } else {
      return .white
    }
  }

  /// light: black / dark: white
  static let staticBlack = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return .white
    } else {
      return .black
    }
  }

  /// static: #F8F9FA
  static let gray100 = UIColor(hexString: "#F8F9FA")

  /// light: #F3F4F5 / dark: #1D1D1D
  static let gray200 = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return UIColor(hexString: "#1D1D1D")
    } else {
      return UIColor(hexString: "#F3F4F5")
    }
  }

  /// light: #EBECED / dark: #2F2F2F
  static let gray300 = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return UIColor(hexString: "#2F2F2F")
    } else {
      return UIColor(hexString: "#EBECED")
    }
  }

  /// light: #D9D9D9 / dark: #6C6C6C
  static let gray400 = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return UIColor(hexString: "#6C6C6C")
    } else {
      return UIColor(hexString: "#D9D9D9")
    }
  }

  /// static: #BBBBBB
  static let gray500 = UIColor(hexString: "#BBBBBB")

  /// static: #909090
  static let gray600 = UIColor(hexString: "#909090")

  /// light: #6C6C6C / dark: #D9D9D9
  static let gray700 = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return UIColor(hexString: "#D9D9D9")
    } else {
      return UIColor(hexString: "#6C6C6C")
    }
  }

  /// light: #2F2F2F / dark: #EBECED
  static let gray800 = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return UIColor(hexString: "#EBECED")
    } else {
      return UIColor(hexString: "#2F2F2F")
    }
  }

  /// light: #1D1D1D / dark: #F3F4F5
  static let gray900 = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return UIColor(hexString: "#F3F4F5")
    } else {
      return UIColor(hexString: "#1D1D1D")
    }
  }

  // MARK: Error

  static let error = UIColor(hexString: "#E34C4B")

  // MARK: Component Color

  static let fabBackgroundColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
    if traitCollection.userInterfaceStyle == .dark {
      return .primary200
    } else {
      return .primary400
    }
  }

  static let fabTextColor = UIColor { (traitCollection: UITraitCollection) -> UIColor in
    if traitCollection.userInterfaceStyle == .dark {
      return .primary700
    } else {
      return .white
    }
  }
}
