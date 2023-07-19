//
//  CreateLinkUseCase.swift
//  Domain
//
//  Created by 박천송 on 2023/07/07.
//

import Foundation

import RxSwift

public protocol CreateLinkUseCase {
  func execute(
    linkBookId: String,
    title: String,
    url: String,
    thumbnailURL: String?,
    tags: [String]
  ) -> Single<Link>
}

public class CreateLinkUseCaseImpl: CreateLinkUseCase {

  private let linkRepository: LinkRepository

  public init(linkRepository: LinkRepository) {
    self.linkRepository = linkRepository
  }

  public func execute(linkBookId: String, title: String, url: String, thumbnailURL: String?, tags: [String])
    -> Single<Link> {
    linkRepository.createLink(
      linkBookId: linkBookId,
      title: title,
      url: url,
      thumbnailURL: thumbnailURL,
      tags: tags
    )
  }
}
