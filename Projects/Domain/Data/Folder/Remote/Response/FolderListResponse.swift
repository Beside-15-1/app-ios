//
//  FolderListResponse.swift
//  Domain
//
//  Created by 박천송 on 2023/07/07.
//

import Foundation

import Domain

struct FolderListResponse: Codable {
  let totalLinkCount: Int
  let linkBooks: [FolderDTO]

  enum CodingKeys: String, CodingKey {
    case totalLinkCount
    case linkBooks
  }

  func toDomain()-> [Folder] {
    linkBooks.map {
      .init(
        id: $0.id,
        userID: $0.userID,
        title: $0.title,
        backgroundColor: $0.backgroundColor,
        titleColor: $0.titleColor,
        linkCount: $0.linkCount,
        createdAt: $0.createdAt,
        lastSavedAt: $0.lastSavedAt
      )
    }
  }
}
