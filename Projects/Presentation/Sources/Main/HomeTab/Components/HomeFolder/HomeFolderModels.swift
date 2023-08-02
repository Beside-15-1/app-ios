//
//  HomeFolderModels.swift
//  PresentationInterface
//
//  Created by 박천송 on 2023/07/07.
//

import Foundation

struct HomeFolderSectionViewModel: Hashable {

  let section: HomeFolderSection
  var items: [HomeFolderCell.ViewModel]
}

enum HomeFolderSection: Hashable {
  case normal
}
