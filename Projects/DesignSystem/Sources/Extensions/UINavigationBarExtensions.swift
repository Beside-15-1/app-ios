//
//  UINavigationBarExtensions.swift
//  DesignSystem
//
//  Created by 박천송 on 2023/08/28.
//

import Foundation
import UIKit

extension UINavigationItem {

  public func configureLeftBarButtonItems(with items: [UIBarButtonItem]) {
    leftBarButtonItems = insertedFixedSpaceBetweenItems(from: items)
  }

  public func configureRightBarButtonItems(with items: [UIBarButtonItem]) {
    rightBarButtonItems = insertedFixedSpaceBetweenItems(from: items)
  }

  private func insertedFixedSpaceBetweenItems(from items: [UIBarButtonItem]) -> [UIBarButtonItem] {
    items.flatMap { item in
      if item == items.last {
        return [item]
      }

      return [item, UIBarButtonItem(systemItem: .fixedSpace).then { $0.width = 14.0 }]
    }
  }
}
