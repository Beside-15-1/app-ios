//
//  UpdateLinkUseCase.swift
//  Domain
//
//  Created by 박천송 on 2023/07/19.
//

import Foundation

import RxSwift

public protocol UpdateLinkUseCase {
  func execute(
    id: String,
    title: String,
    url: String,
    thumbnailURL: String?,
    tags: [String]
  ) -> Single<Link>
}

public class UpdateLinkUseCaseImpl: UpdateLinkUseCase {

  private let linkRepository: LinkRepository

  public init(linkRepository: LinkRepository) {
    self.linkRepository = linkRepository
  }

  public func execute(id: String, title: String, url: String, thumbnailURL: String?, tags: [String])
    -> Single<Link> {
    linkRepository.updateLink(
      id: id,
      title: title,
      url: url,
      thumbnailURL: thumbnailURL,
      tags: tags
    )
  }
}
