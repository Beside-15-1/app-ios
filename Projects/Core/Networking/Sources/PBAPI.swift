//
//  Network.swift
//  Core
//
//  Created by Hohyeon Moon on 2023/04/28.
//

import Foundation
import Moya

public let provider = MoyaProvider<PBAPI>()

// MARK: - PBAPI

public enum PBAPI {
  case validateAppleUser(token: String, identity: String)
}

// MARK: TargetType

extension PBAPI: TargetType {
  public var baseURL: URL {
    URL(string: "http://49.50.165.241")!
  }

  public var path: String {
    switch self {
    case .validateAppleUser:
      return "/api/auth/apple"
    }
  }

  public var method: Moya.Method {
    switch self {
    case .validateAppleUser:
      return .post
    }
  }

  public var task: Moya.Task {
    switch self {
    case let .validateAppleUser(token, identity):
      return .requestParameters(
        parameters: ["token": token, "id_token": identity],
        encoding: JSONEncoding.default
      )
    }
  }

  public var headers: [String: String]? {
    return ["Content-type": "application/json"]
  }
}

public extension Moya.Response {
  func map<D: Decodable>(_ type: D.Type) throws -> D {
    let decoder = JSONDecoder()

    do {
      return try decoder.decode(D.self, from: data)
    } catch {
      throw error
    }
  }
}
