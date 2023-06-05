import Foundation
import Moya

// MARK: - TokenAPI

enum TokenAPI {
  case refreshToken(String, String)
}

// MARK: TargetType

extension TokenAPI: TargetType {
  var baseURL: URL {
    URL(string: "https://joosum.com")!
  }

  var path: String {
    switch self {
    case .refreshToken:
      return ""
    }
  }

  var method: Moya.Method {
    switch self {
    case .refreshToken:
      return .post
    }
  }

  var task: Moya.Task {
    switch self {
    case let .refreshToken(access, refresh):
      return .requestParameters(
        parameters: [
          "accessToken": access,
          "refreshToken": refresh
        ],
        encoding: JSONEncoding.default
      )
    }
  }

  var headers: [String: String]? {
    ["Content-type": "application/json"]
  }
}
