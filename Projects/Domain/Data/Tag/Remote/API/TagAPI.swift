//
//  TagAPI.swift
//  Data
//
//  Created by 박천송 on 2023/08/07.
//

import Foundation

import Moya
import PBNetworking

enum TagAPI {
  case fetchTagList
  case updateTagList([String])
}

extension TagAPI: BaseTargetType {

  var path: String {
    switch self {
    case .fetchTagList:
      return "tags"
      
    case .updateTagList:
      return "tags"
    }
  }

  var method: Moya.Method {
    switch self {
    case .fetchTagList:
      return .get

    case .updateTagList:
      return .post
    }
  }

  var task: Task {
    switch self {
    case .fetchTagList:
      return .requestPlain

    case .updateTagList(let array):
      return .requestJSONEncodable(array)
    }
  }
}
