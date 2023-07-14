//
//  DeleteFolderUseCase.swift
//  Domain
//
//  Created by 박천송 on 2023/07/14.
//

import Foundation

import RxSwift

public protocol DeleteFolderUseCase {
  func execute(id: String) -> Single<Void>
}

public final class DeleteFolderUseCaseImpl: DeleteFolderUseCase {

  private let folderRepository: FolderRepository

  public init(folderRepository: FolderRepository) {
    self.folderRepository = folderRepository
  }

  public func execute(id: String) -> Single<Void> {
    folderRepository.deleteFolder(id: id)
  }
}
