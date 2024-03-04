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
  case fetchTagList
  case updateTagList([String])
  case deleteTag(String)
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

    case .fetchTagList:
      return "tags"

    case .updateTagList:
      return "tags"

    case .deleteTag(let tag):
      return "tags/\(tag)"
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

    case .fetchTagList:
      return .get

    case .updateTagList:
      return .post

    case .deleteTag:
      return .delete
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

    case .fetchTagList:
      return .requestPlain

    case .updateTagList(let array):
      return .requestJSONEncodable(array)

    case .deleteTag:
      return .requestPlain
    }
  }
}

