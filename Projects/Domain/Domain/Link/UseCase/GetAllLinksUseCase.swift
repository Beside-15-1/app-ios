//
//  GetAllLinksUseCase.swift
//  Domain
//
//  Created by 박천송 on 2023/07/25.
//

import Foundation

import RxSwift

public protocol GetAllLinksUseCase {
  func execute() -> [Link]
}

public class GetAllLinksUseCaseImpl: GetAllLinksUseCase {

  private let linkRepository: LinkRepository

  public init(linkRepository: LinkRepository) {
    self.linkRepository = linkRepository
  }

  public func execute() -> [Link] {
    linkRepository.getAllLinks()
  }
}
