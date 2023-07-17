//
//  ComponentsDarkModeColor.swift
//  DesignSystem
//
//  Created by 박천송 on 2023/06/10.
//

import Foundation
import UIKit

extension UIColor {
  // MARK: Paper - Background

  public static let paperWhite = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return .black
    } else {
      return .white
    }
  }

  public static let paperGray = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return UIColor(hexString: "#2F2F2F")
    } else {
      return UIColor(hexString: "#EFECFF")
    }
  }

  public static let paperCard = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return UIColor(hexString: "#1D1D1D")
    } else {
      return .white
    }
  }

  public static let paperAboveBg = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return UIColor(hexString: "#2B1E7A")
    } else {
      return UIColor(hexString: "#5242BF")
    }
  }

  // MARK: FAB

  public static let fabTextColor = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return UIColor(hexString: "#221959")
    } else {
      return .white
    }
  }

  // MARK: BasicButton

  public static let basicButtonPressedColor = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return UIColor(hexString: "#392A95")
    } else {
      return UIColor(hexString: "#2E2277")
    }
  }

  // MARK: TextButton

  public static let textButtonColor = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return .white
    } else {
      return UIColor(hexString: "#6C6C6C")
    }
  }

  // MARK: InputField

  public static let inputContainerEditing = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return UIColor(hexString: "#2E2277")
    } else {
      return UIColor(hexString: "#EFECFF")
    }
  }

  public static let modalBackgorund: UIColor = .black.withAlphaComponent(0.6)
}
