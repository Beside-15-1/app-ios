//
//  MoveFolderModels.swift
//  PresentationInterface
//
//  Created by 박천송 on 2023/07/19.
//

import Foundation

struct MoveFolderSectionViewModel: Hashable {

  let section: MoveFolderSection
  var items: [MoveFolderCell.ViewModel]
}

enum MoveFolderSection: Hashable {
  case normal
}
