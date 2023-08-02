//
//  DeleteLinkUseCase.swift
//  Domain
//
//  Created by 박천송 on 2023/07/19.
//

import Foundation

import RxSwift

public protocol DeleteLinkUseCase {
  func execute(id: String) -> Single<Void>
}

public final class DeleteLinkUseCaseImpl: DeleteLinkUseCase {

  private let linkRepository: LinkRepository

  public init(linkRepository: LinkRepository) {
    self.linkRepository = linkRepository
  }

  public func execute(id: String) -> Single<Void> {
    linkRepository.deleteLink(id: id)
  }
}
