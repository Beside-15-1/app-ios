//
//  FolderAPI.swift
//  Data
//
//  Created by 박천송 on 2023/07/07.
//

import Foundation

import Moya
import PBNetworking

enum FolderAPI {
  case fetchFolderList(sort: String)
  case createFolder(CreateFolderRequest)
  case updateFolder(id: String, request: CreateFolderRequest)
  case deleteFolder(id: String)
}

extension FolderAPI: BaseTargetType {

  var path: String {
    switch self {
    case .fetchFolderList:
      return "link-books"

    case .createFolder:
      return "link-books"

    case .updateFolder(let id, _):
      return "link-books/\(id)"

    case .deleteFolder(let id):
      return "link-books/\(id)"
    }
  }

  var method: Moya.Method {
    switch self {
    case .fetchFolderList:
      return .get

    case .createFolder:
      return .post

    case .updateFolder:
      return .put

    case .deleteFolder:
      return .delete
    }
  }

  var task: Moya.Task {
    switch self {
    case .fetchFolderList(let sort):
      return .requestParameters(parameters: ["sort": sort], encoding: URLEncoding.queryString)

    case .createFolder(let request):
      return .requestJSONEncodable(request)

    case .updateFolder(_, let request):
      return .requestJSONEncodable(request)

    case .deleteFolder:
      return .requestPlain
    }
  }
}
