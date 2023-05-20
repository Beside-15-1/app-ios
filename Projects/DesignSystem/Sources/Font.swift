//
//  Font.swift
//  DesignSystem
//
//  Created by 박천송 on 2023/05/16.
//

import Foundation
import UIKit

public enum Pretendard {
  case black
  case bold
  case extraBold
  case extraLight
  case light
  case medium
  case regular
  case semiBold
  case thin
}

public extension UIFont {
  static func pretendard(_ type: Pretendard, size: CGFloat)-> UIFont {
    switch type {
    case .regular:
      return DesignSystemFontFamily.Pretendard.regular.font(size: size)
    case .medium:
      return DesignSystemFontFamily.Pretendard.medium.font(size: size)
    case .black:
      return DesignSystemFontFamily.Pretendard.black.font(size: size)
    case .bold:
      return DesignSystemFontFamily.Pretendard.bold.font(size: size)
    case .extraBold:
      return DesignSystemFontFamily.Pretendard.extraBold.font(size: size)
    case .extraLight:
      return DesignSystemFontFamily.Pretendard.extraLight.font(size: size)
    case .light:
      return DesignSystemFontFamily.Pretendard.light.font(size: size)
    case .thin:
      return DesignSystemFontFamily.Pretendard.thin.font(size: size)
    case .semiBold:
      return DesignSystemFontFamily.Pretendard.semiBold.font(size: size)
    }
  }
}
