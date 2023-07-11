//
//  FetchLinksInLinkBookUseCase.swift
//  Domain
//
//  Created by 박천송 on 2023/07/11.
//

import Foundation

import RxSwift

public protocol FetchLinksInLinkBookUseCase {
  func execute(linkBookId: String) -> Single<[Link]>
}

public class FetchLinksInLinkBookUseCaseImpl: FetchLinksInLinkBookUseCase {

  private let linkRepository: LinkRepository

  public init(linkRepository: LinkRepository) {
    self.linkRepository = linkRepository
  }

  public func execute(linkBookId: String) -> Single<[Link]> {
    linkRepository.fetchLinksInLinkBook(linkBookID: linkBookId)
  }
}
