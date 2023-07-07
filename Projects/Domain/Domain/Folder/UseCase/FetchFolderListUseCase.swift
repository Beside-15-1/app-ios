//
//  FetchFolderListUseCase.swift
//  Domain
//
//  Created by 박천송 on 2023/07/07.
//

import Foundation

import RxSwift

public protocol FetchFolderListUseCase {
  func execute(sort: FolderSortingType) -> Single<[Folder]>
}

public class FetchFolderListUseCaseImpl: FetchFolderListUseCase {

  private let folderRepository: FolderRepository

  public init(folderRepository: FolderRepository) {
    self.folderRepository = folderRepository
  }

  public func execute(sort: FolderSortingType) -> Single<[Folder]> {
    folderRepository.fetchFolderList(sort: sort.rawValue)
  }
}
