//
//  TagListSection.swift
//  Presentation
//
//  Created by 박천송 on 3/4/24.
//

import Foundation

import Domain

enum TagListSection: Hashable {
  case items
}

extension TagListSection {
  enum Item: Hashable {
    case normal(Tag)
  }
}
