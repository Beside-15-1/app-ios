//
//  LinkSortingType.swift
//  Domain
//
//  Created by 박천송 on 2023/07/17.
//

import Foundation

public enum LinkSortingType: String, Hashable {
  case createAt = "created_at"
  case updatedAt = "updated_at"
  case title
  case lastedAt

  public var api: String {
    switch self {
    case .createAt:
      return "created_at"
    case .updatedAt:
      return "updated_at"
    case .title:
      return "title"
    case .lastedAt:
      return "created_at"
    }
  }

  public var title: String {
    switch self {
    case .createAt:
      return "최신순"
    case .updatedAt:
      return "업데이트 순"
    case .title:
      return "제목순"
    case .lastedAt:
      return "오래된순"
    }
  }
}

public enum SortingOrderType: String, Hashable {
  case asc
  case desc
}
