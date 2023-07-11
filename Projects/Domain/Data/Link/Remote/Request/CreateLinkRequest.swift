//
//  CreateLinkRequest.swift
//  Data
//
//  Created by 박천송 on 2023/07/11.
//

import Foundation

struct CreateLinkRequest: Codable {
  let linkBookId: String
  let title: String
  let url: String
  let thumbnailURL: String?
  let tags: [String]
}
