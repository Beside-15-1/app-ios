//
//  Link.swift
//  Domain
//
//  Created by 박천송 on 2023/07/07.
//

import Foundation

public struct Link: Hashable {
  let id: String
  let folderId: String

  let readCount: Int
  let title: String
  let url: String
  let userId: String

  let createdAt: String
  let lastReadAt: String
  let updatedAt: String
}
