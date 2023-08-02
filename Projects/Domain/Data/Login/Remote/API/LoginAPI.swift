import Foundation

import Moya
import PBNetworking

// MARK: - LoginAPI

enum LoginAPI {
  case google(String)
  case apple(String)
  case signUp(SignUpRequest)
  case getMe
  case deleteAccount
}

// MARK: TargetType

extension LoginAPI: BaseTargetType {

  var path: String {
    switch self {
    case .google:
      return "auth/google"

    case .apple:
      return "auth/apple"

    case .signUp:
      return "auth/signup"

    case .getMe:
      return "auth/me"

    case .deleteAccount:
      return "auth/me"
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

    case .getMe:
      return .get

    case .deleteAccount:
      return .delete
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

    case .getMe:
      return .requestPlain

    case .deleteAccount:
      return .requestPlain
    }
  }

  public var authorizationType: AuthorizationType? {
    switch self {
    case .google, .apple, .signUp:
      return nil

    case .getMe, .deleteAccount:
      return .bearer
    }
  }
}
