//
//  FolderDetailModels.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/17.
//

import Foundation

struct FolderDetailSectionViewModel: Hashable {

  let section: FolderDetailSection
  var items: [FolderDetailCell.ViewModel]
}

enum FolderDetailSection: Hashable {
  case normal
}
