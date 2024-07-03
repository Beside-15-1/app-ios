//
//  HomeFeedModels.swift
//  Presentation
//
//  Created by 박천송 on 6/21/24.
//

import Foundation

struct HomeSectionViewModel: Hashable {

  let section: HomeFeedSection
  var items: [HomeFeedSectionItem]
}

enum HomeFeedSection: Hashable {
  case normal
  case more
}

enum HomeFeedSectionItem: Hashable {
  case link(HomeFeedCell.ViewModel)
  case more
}
