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
  case fetchFolderList
}

extension API: BaseTargetType {

  var path: String {
    switch self {
    case .createLink:
      return "links"

    case .fetchFolderList:
      return "link-books"
    }
  }

  var method: Moya.Method {
    switch self {
    case .createLink:
      return .post

    case .fetchFolderList:
      return .get
    }
  }

  var task: Moya.Task {
    switch self {
    case .createLink(let request):
      return .requestJSONEncodable(request)

    case .fetchFolderList:
      return .requestParameters(parameters: ["sort": "create_at"], encoding: URLEncoding.queryString)
    }
  }
}

