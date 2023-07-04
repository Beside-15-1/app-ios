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
  public var illustration: String?
  public var linkCount: Int

  public init() {
    title = "기본"
    backgroundColor = "#6D6D6F"
    titleColor = "#FFFFFF"
    illustration = nil
    linkCount = 0
  }

  public init(
    title: String,
    backgroundColor: String,
    titleColor: String,
    illustration: String?,
    linkCount: Int = 0
  ) {
    self.title = title
    self.backgroundColor = backgroundColor
    self.titleColor = titleColor
    self.illustration = illustration
    self.linkCount = linkCount
  }
}
