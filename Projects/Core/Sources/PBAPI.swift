//
//  Network.swift
//  Core
//
//  Created by Hohyeon Moon on 2023/04/28.
//

import Foundation
import Moya

// MARK: - PBAPI

enum PBAPI {
  case createUser(name: String, email: String)
}

// MARK: TargetType

extension PBAPI: TargetType {
  var baseURL: URL {
    URL(string: "https://joosum.com")!
  }

  var path: String {
    switch self {
    case .createUser:
      return "/users"
    }
  }

  var method: Moya.Method {
    switch self {
    case .createUser:
      return .post
    }
  }

  var task: Moya.Task {
    switch self {
    case let .createUser(name, email):
      return .requestParameters(
        parameters: ["name": name, "email": email],
        encoding: JSONEncoding.default
      )
    }
  }

  var headers: [String: String]? {
    return ["Content-type": "application/json"]
  }
}
