//
//  FolderSortingType.swift
//  Domain
//
//  Created by 박천송 on 2023/07/07.
//

import Foundation

public enum FolderSortingType: String, Hashable {
  case createAt = "create_at"
  case lastSavedAt = "last_saved_at"
  case title = "title"
}
