//
//  SelectFolderSectionViewModel.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/04.
//

import Foundation

import Domain

struct SelectFolderSectionViewModel: Hashable {

  let section: SelectFolderSection
  var items: [SelectFolderSectionItem]
}

enum SelectFolderSection: Hashable {
  case myFolder
}

enum SelectFolderSectionItem: Hashable {
  case folder(Folder)
}
