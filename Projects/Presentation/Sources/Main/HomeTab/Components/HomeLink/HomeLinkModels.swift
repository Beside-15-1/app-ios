//
//  HomeLinkModels.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/07.
//

struct HomeLinkSectionViewModel: Hashable {

  let section: HomeLinkSection
  var items: [HomeLinkCell.ViewModel]
}

enum HomeLinkSection: Hashable {
  case normal
}
