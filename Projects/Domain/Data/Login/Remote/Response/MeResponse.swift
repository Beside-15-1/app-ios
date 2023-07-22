//
//  MeResponse.swift
//  Data
//
//  Created by 박천송 on 2023/07/21.
//

import Foundation

struct MeResponse: Codable {

  let age: Int
  let createdAt: String
  let email: String
  let gender: String
  let id: String
  let name: String
  let social: String
  let updatedAt: String
  let userId: String

  enum CodingKeys: CodingKey {
    case age
    case createdAt
    case email
    case gender
    case id
    case name
    case social
    case updatedAt
    case userId
  }
}
