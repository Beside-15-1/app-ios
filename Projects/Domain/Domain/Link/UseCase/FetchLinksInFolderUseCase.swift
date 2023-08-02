//
//  FetchLinksInFolderUseCase.swift
//  Domain
//
//  Created by 박천송 on 2023/07/11.
//

import Foundation

import RxSwift

public protocol FetchLinksInFolderUseCase {
  func execute(linkBookId: String, sort: LinkSortingType, order: SortingOrderType) -> Single<[Link]>
}

public class FetchLinksInFolderUseCaseImpl: FetchLinksInFolderUseCase {

  private let linkRepository: LinkRepository

  public init(linkRepository: LinkRepository) {
    self.linkRepository = linkRepository
  }

  public func execute(linkBookId: String, sort: LinkSortingType, order: SortingOrderType) -> Single<[Link]> {
    linkRepository.fetchLinksInLinkBook(linkBookID: linkBookId, sort: sort, order: order)
  }
}
