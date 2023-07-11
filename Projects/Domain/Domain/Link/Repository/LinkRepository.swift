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
  ) -> Single<Void>

  func fetchAllLinks() -> Single<[Link]>
  func fetchLinksInLinkBook(linkBookID: String) -> Single<[Link]>
}
