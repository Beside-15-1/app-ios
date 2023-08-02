//
//  FolderDTO.swift
//  Domain
//
//  Created by 박천송 on 2023/07/07.
//

import Foundation

struct FolderDTO: Codable {
  let id: String
  let userID: String
  let title: String
  let backgroundColor: String
  let titleColor: String
  let illustration: String?
  let linkCount: Int
  let createdAt: String
  let lastSavedAt: String
  let isDefault: String

  enum CodingKeys: String, CodingKey {
    case id = "linkBookId"
    case userID = "userId"
    case title
    case backgroundColor
    case titleColor
    case illustration
    case linkCount
    case createdAt
    case lastSavedAt
    case isDefault
  }
}
