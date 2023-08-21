//
//  LinkDTO.swift
//  ShareExtension
//
//  Created by 박천송 on 2023/08/21.
//

import Foundation

import Domain

struct LinkDTO: Codable {
  let id: String
  let linkBookId: String
  let userId: String

  let readCount: Int
  let title: String
  let url: String
  let thumbnailURL: String?
  let tags: [String]?
  let linkBookName: String

  let createdAt: String
  let lastReadAt: String
  let updatedAt: String

  enum CodingKeys: String, CodingKey {
    case id = "linkId"
    case linkBookId
    case userId
    case readCount
    case title
    case url
    case thumbnailURL
    case tags
    case linkBookName
    case createdAt
    case lastReadAt
    case updatedAt
  }

  func toDomain() -> Link {
    .init(
      id: id,
      linkBookId: linkBookId,
      userId: userId,
      readCount: readCount,
      title: title,
      url: url,
      thumbnailURL: thumbnailURL,
      tags: tags ?? [],
      folderName: linkBookName,
      createdAt: createdAt,
      lastReadAt: lastReadAt,
      updatedAt: updatedAt
    )
  }
}
