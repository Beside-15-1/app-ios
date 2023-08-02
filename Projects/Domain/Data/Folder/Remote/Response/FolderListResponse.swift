//
//  FolderListResponse.swift
//  Domain
//
//  Created by 박천송 on 2023/07/07.
//

import Foundation

import Domain

struct FolderListResponse: Codable {
  let linkBooks: [FolderDTO]
  let totalLinkCount: Int?

  enum CodingKeys: String, CodingKey {
    case linkBooks
    case totalLinkCount
  }

  func toDomain()-> FolderList {
    FolderList(folders: linkBooks.map {
      .init(
        id: $0.id,
        userID: $0.userID,
        title: $0.title,
        backgroundColor: $0.backgroundColor,
        titleColor: $0.titleColor,
        illustration: $0.illustration,
        linkCount: $0.linkCount,
        createdAt: $0.createdAt,
        lastSavedAt: $0.lastSavedAt,
        isDefault: $0.isDefault == "y"
      )
    }, totalLinkCount: totalLinkCount ?? 0)
  }
}


