//
//  LinkRepository.swift
//  Domain
//
//  Created by 박천송 on 2023/07/07.
//

import Foundation

import RxSwift

public protocol LinkRepository {
  func createLink(
    linkBookId: String,
    title: String,
    url: String,
    thumbnailURL: String?,
    tags: [String]
  ) -> Single<Link>

  func fetchAllLinks(sort: LinkSortingType, order: SortingOrderType) -> Single<[Link]>
  func fetchLinksInLinkBook(linkBookID: String, sort: LinkSortingType, order: SortingOrderType) -> Single<[Link]>
  func deleteLink(id: String) -> Single<Void>
  func updateLink(
    id: String,
    title: String,
    url: String,
    thumbnailURL: String?,
    tags: [String]
  ) -> Single<Link>

  func updateLink(
    id: String,
    folderID: String
  ) -> Single<Void>

  func getAllLinks() -> [Link]

  func read(id: String) -> Single<Void>

  func fetchThumbnail(url: String) -> Single<Thumbnail>

  func deleteMultipleLink(idList: [String]) -> Single<Void>
}
