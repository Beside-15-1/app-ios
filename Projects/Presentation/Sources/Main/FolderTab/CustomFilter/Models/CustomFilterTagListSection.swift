//
//  CustomFilterTagListSection.swift
//  Presentation
//
//  Created by 박천송 on 12/21/23.
//

import Foundation

enum CustomFilterTagListSection: Hashable {
  case items
}

extension CustomFilterTagListSection {
  enum Item: Hashable {
    case normal(CustomFilterTagCell.ViewModel)
  }
}
