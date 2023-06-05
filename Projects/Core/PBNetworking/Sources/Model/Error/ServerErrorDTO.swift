import Foundation

struct ServerErrorDTO: Codable {
  let code: String
  let message: String

  enum CodingKeys: CodingKey {
    case code
    case message
  }
}
