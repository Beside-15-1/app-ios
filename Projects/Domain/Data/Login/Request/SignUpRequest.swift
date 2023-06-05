import Foundation

struct SignUpRequest: Codable {
  let accessToken: String
  let age: Int
  let gender: String
  let nickname: String
  let social: String

  enum CodingKeys: String, CodingKey {
    case accessToken
    case age
    case gender
    case nickname
    case social
  }
}
