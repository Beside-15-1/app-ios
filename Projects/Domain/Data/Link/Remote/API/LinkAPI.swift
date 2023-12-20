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
  case deleteLink(id: String)
  case updateLink(id: String, UpdateLinkRequest)
  case updateLinkWithFolderID(id: String, folderID: String)
  case readLink(id: String)
  case fetchThumbnail(url: String)
  case deleteMultipleLink(idList: [String])
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

    case .deleteLink(let id):
      return "links/\(id)"

    case .updateLink(let id, _):
      return "links/\(id)"

    case .updateLinkWithFolderID(let id, let folderID):
      return "links/\(id)/link-book-id/\(folderID)"

    case .readLink(let id):
      return "/links/\(id)/read-count"

    case .fetchThumbnail:
      return "links/thumbnail"

    case .deleteMultipleLink(let list):
      return "links"
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

    case .deleteLink:
      return .delete

    case .updateLink:
      return .put

    case .updateLinkWithFolderID:
      return .put

    case .readLink:
      return .put

    case .fetchThumbnail:
      return .post

    case .deleteMultipleLink:
      return .delete
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
          "order": order.rawValue,
        ],
        encoding: URLEncoding.queryString
      )

    case .fetchLinksInLinkBook(_, let sort, let order):
      return .requestParameters(
        parameters: [
          "sort": sort.api,
          "order": order.rawValue,
        ],
        encoding: URLEncoding.queryString
      )

    case .deleteLink:
      return .requestPlain

    case .updateLink(_, let request):
      return .requestJSONEncodable(request)

    case .updateLinkWithFolderID:
      return .requestPlain

    case .readLink:
      return .requestPlain

    case .fetchThumbnail(let url):
      return .requestJSONEncodable(["url": url])

    case .deleteMultipleLink(let list):
      return .requestJSONEncodable(["linkIds": list])
    }
  }
}
