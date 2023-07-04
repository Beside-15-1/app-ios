//
//  Folder.swift
//  Domain
//
//  Created by 박천송 on 2023/07/04.
//

import Foundation

public struct Folder: Hashable {
  public var title: String
  public var backgroundColor: String
  public var titleColor: String
  public var image: String?
  public var linkCount: Int

  public init() {
    title = "기본"
    backgroundColor = "#6D6D6F"
    titleColor = "#FFFFFF"
    image = nil
    linkCount = 0
  }

  public init(
    title: String,
    backgroundColor: String,
    titleColor: String,
    image: String,
    linkCount: Int
  ) {
    self.title = title
    self.backgroundColor = backgroundColor
    self.titleColor = titleColor
    self.image = image
    self.linkCount = linkCount
  }
}
