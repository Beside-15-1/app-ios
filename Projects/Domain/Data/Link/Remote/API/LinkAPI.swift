//
//  LinkAPI.swift
//  Data
//
//  Created by 박천송 on 2023/07/11.
//

import Foundation

import Domain
import Moya
import PBNetworking

enum LinkAPI {
  case createLink(CreateLinkRequest)
  case fetchAll(LinkSortingType, SortingOrderType)
  case fetchLinksInLinkBook(String, LinkSortingType, SortingOrderType)
}

extension LinkAPI: BaseTargetType {

  var path: String {
    switch self {
    case .createLink:
      return "links"

    case .fetchAll:
      return "links"

    case .fetchLinksInLinkBook(let id, _, _):
      return "link-books/\(id)/links"
    }
  }

  var method: Moya.Method {
    switch self {
    case .createLink:
      return .post

    case .fetchAll:
      return .get

    case .fetchLinksInLinkBook:
      return .get
    }
  }

  var task: Moya.Task {
    switch self {
    case .createLink(let request):
      return .requestJSONEncodable(request)

    case .fetchAll(let sort, let order):
      return .requestParameters(
        parameters: [
          "sort": sort.api,
          "order": order.rawValue
        ],
        encoding: URLEncoding.queryString
      )

    case .fetchLinksInLinkBook(_, let sort, let order):
      return .requestParameters(
        parameters: [
          "sort": sort.api,
          "order": order.rawValue
        ],
        encoding: URLEncoding.queryString
      )
    }
  }
}

