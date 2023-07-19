//
//  UpdateLinkRequest.swift
//  Domain
//
//  Created by 박천송 on 2023/07/19.
//

import Foundation

struct UpdateLinkRequest: Codable {
  let title: String
  let url: String
  let thumbnailURL: String?
  let tags: [String]
}
