//
//  MasterSectionViewModel.swift
//  Presentation
//
//  Created by 박천송 on 2023/09/06.
//

import Foundation

import Domain

struct MasterSectionViewModel: Hashable {

  let section: MasterSection
  var items: [MasterTabCell.ViewModel]
}

enum MasterSection: Hashable {
  case normal
}
