import Foundation

struct PBServerErrorDTO: Codable {
  let message: String

  enum CodingKeys: String, CodingKey {
    case message = "error"
  }
}
