//
//  ServerErrorDTO.swift
//  Networking
//
//  Created by 박천송 on 2023/05/12.
//

import Foundation

struct ServerErrorDTO: Codable {
  let code: String
  let message: String

  enum CodingKeys: CodingKey {
    case code
    case message
  }
}
