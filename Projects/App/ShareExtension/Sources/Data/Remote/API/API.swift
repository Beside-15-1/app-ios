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
  case updateLink(id: String, UpdateLinkRequest)
  case updateLinkWithFolderID(id: String, folderID: String)
}

extension API: BaseTargetType {

  var path: String {
    switch self {
    case .createLink:
      return "links"

    case .fetchFolderList:
      return "link-books"

    case .updateLink(let id, _):
      return "links/\(id)"

    case .updateLinkWithFolderID(let id, let folderID):
      return "links/\(id)/link-book-id/\(folderID)"
    }
  }

  var method: Moya.Method {
    switch self {
    case .createLink:
      return .post

    case .fetchFolderList:
      return .get

    case .updateLink:
      return .put

    case .updateLinkWithFolderID:
      return .put
    }
  }

  var task: Moya.Task {
    switch self {
    case .createLink(let request):
      return .requestJSONEncodable(request)

    case .fetchFolderList:
      return .requestParameters(parameters: ["sort": "create_at"], encoding: URLEncoding.queryString)

    case .updateLink(_, let request):
      return .requestJSONEncodable(request)

    case .updateLinkWithFolderID:
      return .requestPlain
    }
  }
}

