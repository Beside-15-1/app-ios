//
//  FetchAllLinksUseCase.swift
//  Domain
//
//  Created by 박천송 on 2023/07/11.
//

import Foundation

import RxSwift

public protocol FetchAllLinksUseCase {
  func execute() -> Single<[Link]>
}

public class FetchAllLinksUseCaseImpl: FetchAllLinksUseCase {

  private let linkRepository: LinkRepository

  public init(linkRepository: LinkRepository) {
    self.linkRepository = linkRepository
  }

  public func execute() -> Single<[Link]> {
    linkRepository.fetchAllLinks()
  }
}
