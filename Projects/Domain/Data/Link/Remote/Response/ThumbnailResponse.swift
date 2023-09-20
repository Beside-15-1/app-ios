//
//  ThumbnailResponse.swift
//  Data
//
//  Created by 박천송 on 2023/09/20.
//

import Foundation

import Domain

struct ThumbnailResponse: Codable {
  let url: String?
  let title: String?
  let thumbnailURL: String?

  func toDomain() -> Thumbnail {
    .init(title: title, url: url, imageURL: thumbnailURL)
  }
}
