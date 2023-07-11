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
}

extension FolderAPI: BaseTargetType {

  var path: String {
    switch self {
    case .fetchFolderList:
      return "link-books"

    case .createFolder:
      return "link-books"
    }
  }

  var method: Moya.Method {
    switch self {
    case .fetchFolderList:
      return .get

    case .createFolder:
      return .post
    }
  }

  var task: Moya.Task {
    switch self {
    case .fetchFolderList(let sort):
      return .requestParameters(parameters: ["sort": sort], encoding: URLEncoding.queryString)

    case .createFolder(let request):
      return .requestJSONEncodable(request)
    }
  }
}
