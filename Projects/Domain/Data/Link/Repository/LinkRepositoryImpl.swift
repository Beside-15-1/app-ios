//
//  LinkRepositoryImpl.swift
//  Data
//
//  Created by 박천송 on 2023/07/11.
//

import Foundation

import RxSwift

import Domain
import PBNetworking

final class LinkRepositoryImpl: LinkRepository {

  private let networking: PBNetworking<LinkAPI>

  private var links: [Link] = []

  init(networking: PBNetworking<LinkAPI>) {
    self.networking = networking
  }

  func createLink(linkBookId: String, title: String, url: String, thumbnailURL: String?, tags: [String]) -> Single<Link> {
    let target = LinkAPI
      .createLink(.init(
        linkBookId: linkBookId,
        title: title,
        url: url,
        thumbnailURL: thumbnailURL,
        tags: tags
      ))

    return networking.request(target: target)
      .map(LinkDTO.self)
      .map { $0.toDomain() }
  }

  func fetchAllLinks(sort: LinkSortingType, order: SortingOrderType) -> Single<[Link]> {
    let target = LinkAPI.fetchAll(sort, order)

    return networking.request(target: target)
      .map([LinkDTO].self)
      .map { [weak self] linkList in
        self?.links = linkList.map { dtos in dtos.toDomain() }
        return linkList.map { dtos in dtos.toDomain() }
      }
  }

  func fetchLinksInLinkBook(linkBookID: String, sort: LinkSortingType, order: SortingOrderType) -> Single<[Link]> {
    let target = LinkAPI.fetchLinksInLinkBook(linkBookID, sort, order)

    return networking.request(target: target)
      .map([LinkDTO].self)
      .map { $0.map { dtos in dtos.toDomain() } }
  }

  func deleteLink(id: String) -> Single<Void> {
    let target = LinkAPI.deleteLink(id: id)

    return networking.request(target: target)
      .map { _ in }
  }

  func updateLink(id: String, title: String, url: String, thumbnailURL: String?, tags: [String]) -> Single<Link> {
    let target = LinkAPI.updateLink(id: id, .init(title: title, url: url, thumbnailURL: thumbnailURL, tags: tags))

    return networking.request(target: target)
      .map(LinkDTO.self)
      .map { $0.toDomain() }
  }

  func updateLink(id: String, folderID: String) -> Single<Void> {
    let target = LinkAPI.updateLinkWithFolderID(id: id, folderID: folderID)

    return networking.request(target: target)
      .map { _ in }
  }

  func getAllLinks() -> [Link] {
    return links
  }

  func read(id: String) -> Single<Void> {
    let target = LinkAPI.readLink(id: id)

    return networking.request(target: target)
      .map { _ in }
  }

  func fetchThumbnail(url: String) -> Single<Thumbnail> {
    let target = LinkAPI.fetchThumbnail(url: url)

    return networking.request(target: target)
      .map(ThumbnailResponse.self)
      .map { $0.toDomain() }
  }

  func deleteMultipleLink(idList: [String]) -> Single<Void> {
    let target = LinkAPI.deleteMultipleLink(idList: idList)

    return networking.request(target: target)
      .map { _ in }
  }
}
