import Foundation

struct Token: Codable {
  let access: String
  let refresh: String

  enum CodingKeys: CodingKey {
    case access
    case refresh
  }
}
