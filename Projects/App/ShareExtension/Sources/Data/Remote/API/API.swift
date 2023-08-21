//
//  API.swift
//  ShareExtension
//
//  Created by 박천송 on 2023/08/17.
//

import Foundation

import Domain
import Moya
import PBNetworking

enum API {
  case createLink(CreateLinkRequest)
}

extension API: BaseTargetType {

  var path: String {
    switch self {
    case .createLink:
      return "links"
    }
  }

  var method: Moya.Method {
    switch self {
    case .createLink:
      return .post
    }
  }

  var task: Moya.Task {
    switch self {
    case .createLink(let request):
      return .requestJSONEncodable(request)
    }
  }
}

