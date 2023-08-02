//
//  GetFolderListUseCase.swift
//  Domain
//
//  Created by 박천송 on 2023/07/25.
//

import Foundation

public protocol GetFolderListUseCase {
  func execute() -> FolderList
}

public class GetFolderListUseCaseImpl: GetFolderListUseCase {

  private let folderRepository: FolderRepository

  public init(folderRepository: FolderRepository) {
    self.folderRepository = folderRepository
  }

  public func execute() -> FolderList {
    folderRepository.getFolderList()
  }
}
