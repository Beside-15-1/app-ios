import Foundation

struct SignUpRequest: Codable {
  let idToken: String
  let age: Int?
  let gender: String?
  let nickname: String?
  let social: String

  enum CodingKeys: String, CodingKey {
    case idToken
    case age
    case gender
    case nickname
    case social
  }
}
