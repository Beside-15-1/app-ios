//
//  TagAndPeriodTagListSection.swift
//  Presentation
//
//  Created by 박천송 on 12/21/23.
//

import Foundation

enum TagAndPeriodTagListSection: Hashable {
  case items
}

extension TagAndPeriodTagListSection {
  enum Item: Hashable {
    case normal(TagAndPeriodTagCell.ViewModel)
  }
}
