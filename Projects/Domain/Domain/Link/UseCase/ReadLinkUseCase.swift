//
//  ReadLinkUseCase.swift
//  Domain
//
//  Created by 박천송 on 2023/08/24.
//

import Foundation

import RxSwift

public protocol ReadLinkUseCase {
  func execute(id: String) -> Single<Void>
}

public final class ReadLinkUseCaseImpl: ReadLinkUseCase {

  private let linkRepository: LinkRepository

  public init(linkRepository: LinkRepository) {
    self.linkRepository = linkRepository
  }

  public func execute(id: String) -> Single<Void> {
    linkRepository.read(id: id)
  }
}
