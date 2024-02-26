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
      return UIColor(hexString: "#1D1D1D")
    } else {
      return UIColor(hexString: "#EBECED")
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
      return UIColor(hexString: "#2B254E")
    } else {
      return UIColor(hexString: "#5242BF")
    }
  }

  public static let customBg = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return UIColor(hexString: "#909090")
    } else {
      return UIColor(hexString: "#EBECED")
    }
  }

  public static let popupBg = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return UIColor(hexString: "#2F2F2F")
    } else {
      return UIColor.white
    }
  }

  public static let border1 = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return UIColor(hexString: "#1D1D1D")
    } else {
      return UIColor(hexString: "#F3F4F5")
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

  public static let inputActiveBg = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return UIColor(hexString: "#0B081E")
    } else {
      return UIColor(hexString: "#EFECFF")
    }
  }

  public static let inputActiveStroke = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return UIColor(hexString: "#6B5FDE")
    } else {
      return UIColor(hexString: "#392A95")
    }
  }

  public static let inputInactiveBg = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return UIColor(hexString: "#1D1D1D")
    } else {
      return UIColor(hexString: "#F3F4F5")
    }
  }

  public static let modalBackgorund: UIColor = .black.withAlphaComponent(0.6)

  // MARK: NaviButton

  public static let naviBtnActive = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return UIColor(hexString: "#A299F6")
    } else {
      return UIColor(hexString: "#392A95")
    }
  }

  // MARK: IllustBG

  public static let illustBg = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return UIColor(hexString: "#BBBBBB")
    } else {
      return UIColor(hexString: "#EBECED")
    }
  }


  // MARK: DatePicker
  public static let datePicker = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return UIColor(hexString: "#221959")
    } else {
      return UIColor(hexString: "#EFECFF")
    }
  }

  public static let toolBar = UIColor { (trait: UITraitCollection) -> UIColor in
    if trait.userInterfaceStyle == .dark {
      return UIColor(hexString: "FFFFFF")
    } else {
      return UIColor(hexString: "#392A95")
    }
  }
}
