//
//  Folder.swift
//  Domain
//
//  Created by 박천송 on 2023/07/04.
//

import Foundation

public struct Folder: Hashable {
  public let id: String
  public let userID: String

  public var title: String
  public var backgroundColor: String
  public var titleColor: String
  public var illustration: String?
  public var linkCount: Int

  public let createdAt: String
  public let lastSavedAt: String
  public let isDefault: Bool

  public init(
    id: String,
    userID: String,
    title: String,
    backgroundColor: String,
    titleColor: String,
    illustration: String? = nil,
    linkCount: Int,
    createdAt: String,
    lastSavedAt: String,
    isDefault: Bool
  ) {
    self.id = id
    self.userID = userID
    self.title = title
    self.backgroundColor = backgroundColor
    self.titleColor = titleColor
    self.illustration = illustration
    self.linkCount = linkCount
    self.createdAt = createdAt
    self.lastSavedAt = lastSavedAt
    self.isDefault = isDefault
  }

  public static func all() -> Folder {
    .init(
      id: "all",
      userID: "all",
      title: "전체",
      backgroundColor: "",
      titleColor: "",
      linkCount: 0,
      createdAt: "",
      lastSavedAt: "",
      isDefault: false
    )
  }
}
