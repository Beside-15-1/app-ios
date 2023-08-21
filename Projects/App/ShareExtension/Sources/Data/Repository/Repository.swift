//
//  Repository.swift
//  ShareExtension
//
//  Created by 박천송 on 2023/08/17.
//

import Foundation

import RxSwift

import Domain
import KeychainAccess
import PBNetworking

class Repository {

  private let networking: PBNetworking<API> = .init(
    keychain: Keychain(service: "com.pinkboss.joosum")
  )

  init() {}

  func createLink(
    linkBookId: String,
    title: String,
    url: String,
    thumbnailURL: String?,
    tags: [String]
  ) -> Single<Link> {
    let target = API.createLink(.init(
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

  func fetchFolderList() -> Single<FolderList> {
    networking.request(target: API.fetchFolderList)
      .map(FolderListResponse.self)
      .map { $0.toDomain() }
  }

  func updateLink(
    id: String,
    title: String,
    url: String,
    thumbnailURL: String?,
    tags: [String]
  ) -> Single<Link> {
    networking.request(target: API.updateLink(
      id: id,
      .init(title: title, url: url, thumbnailURL: thumbnailURL, tags: tags)
    ))
    .map(LinkDTO.self)
    .map { $0.toDomain() }
  }

  func updateLink(
    id: String,
    folderID: String
  ) -> Single<Void> {
    networking.request(target: API.updateLinkWithFolderID(id: id, folderID: folderID))
      .map { _ in }
  }
}
