//
//  UpdateLinkWithFolderUseCase.swift
//  Domain
//
//  Created by 박천송 on 2023/07/19.
//

import Foundation

import RxSwift

public protocol UpdateLinkWithFolderUseCase {
  func execute(
    id: String,
    folderID: String
  ) -> Single<Void>
}

public class UpdateLinkWithFolderUseCaseImpl: UpdateLinkWithFolderUseCase {

  private let linkRepository: LinkRepository

  public init(linkRepository: LinkRepository) {
    self.linkRepository = linkRepository
  }

  public func execute(
    id: String,
    folderID: String
  ) -> Single<Void> {
    linkRepository.updateLink(id: id, folderID: folderID)
  }
}
