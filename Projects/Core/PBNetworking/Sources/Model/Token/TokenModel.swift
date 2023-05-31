//
//  TokenModel.swift
//  Networking
//
//  Created by 박천송 on 2023/05/12.
//

import Foundation

struct Token: Codable {
  let access: String
  let refresh: String

  enum CodingKeys: CodingKey {
    case access
    case refresh
  }
}
