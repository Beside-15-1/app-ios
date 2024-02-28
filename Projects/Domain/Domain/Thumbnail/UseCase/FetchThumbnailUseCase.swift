//
//  FetchThumbnailUseCase.swift
//  Domain
//
//  Created by 박천송 on 2023/07/04.
//

import Foundation
import LinkPresentation

import RxSwift

public protocol FetchThumbnailUseCase {
  func execute(url: String) -> Single<Thumbnail>
}

public class FetchThumbnailUseCaseImpl: FetchThumbnailUseCase {

  private let linkRepository: LinkRepository

  public init(linkRepository: LinkRepository) {
    self.linkRepository = linkRepository
  }

  public func execute(url: String) -> Single<Thumbnail> {
    linkRepository.fetchThumbnail(url: url)
  }
}
