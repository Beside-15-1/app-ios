//
//  FolderList.swift
//  Domain
//
//  Created by 박천송 on 2023/07/25.
//

import Foundation

public struct FolderList: Hashable {
  public let folders: [Folder]
  public let totalLinkCount: Int

  public init(
    folders: [Folder],
    totalLinkCount: Int
  ) {
    self.folders = folders
    self.totalLinkCount = totalLinkCount
  }
}
