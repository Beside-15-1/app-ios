//
//  LoginAPI.swift
//  Data
//
//  Created by 박천송 on 2023/05/12.
//

import Foundation

import Moya

// MARK: - LoginAPI

enum LoginAPI {
  case google(String)
  case apple(identity: String, authorization: String)
}

// MARK: TargetType

extension LoginAPI: TargetType {
  var baseURL: URL {
    URL(string: "http://49.50.165.241")!
  }

  var path: String {
    switch self {
    case .google:
      return "api"

    case .apple:
      return "api"
    }
  }

  var method: Moya.Method {
    switch self {
    case .google:
      return .get

    case .apple:
      return .get
    }
  }

  var task: Moya.Task {
    switch self {
    case .google:
      return .requestPlain

    case .apple:
      return .requestPlain
    }
  }

  var headers: [String: String]? {
    nil
  }
}
