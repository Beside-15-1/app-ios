import Foundation

import Moya

// MARK: - LoginAPI

enum LoginAPI {
  case google(String)
  case apple(String)
  case signUp(SignUpRequest)
}

// MARK: TargetType

extension LoginAPI: TargetType {
  var baseURL: URL {
    URL(string: "http://49.50.165.241/api")!
  }

  var path: String {
    switch self {
    case .google:
      return "auth/google"

    case .apple:
      return "auth/apple"

    case .signUp:
      return "auth/signup"
    }
  }

  var method: Moya.Method {
    switch self {
    case .google:
      return .post

    case .apple:
      return .post

    case .signUp:
      return .post
    }
  }

  var task: Moya.Task {
    switch self {
    case let .google(token):
      return .requestJSONEncodable(["idToken": token])

    case let .apple(token):
      return .requestJSONEncodable(["idToken": token])

    case let .signUp(request):
      return .requestJSONEncodable(request)
    }
  }

  var headers: [String: String]? {
    nil
  }
}
