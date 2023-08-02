//
//  CreateFolderRequest.swift
//  Data
//
//  Created by 박천송 on 2023/07/07.
//

import Foundation

struct CreateFolderRequest: Codable {
  let backgroundColor: String
  let illustration: String?
  let title: String
  let titleColor: String

  enum CodingKeys: CodingKey {
    case backgroundColor
    case illustration
    case title
    case titleColor
  }
}

