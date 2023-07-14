//
//  MyFolderModels.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/14.
//

import Foundation

struct MyFolderSectionViewModel: Hashable {

  let section: MyFolderSection
  var items: [MyFolderCell.ViewModel]
}

enum MyFolderSection: Hashable {
  case normal
}
