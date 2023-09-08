//
//  BindFolderListUseCase.swift
//  Domain
//
//  Created by 박천송 on 2023/09/07.
//

import Foundation

import RxSwift
import RxRelay

public protocol BindFolderListUseCase {
  func execute() -> BehaviorRelay<FolderList>
}

public final class BindFolderListUseCaseImpl: BindFolderListUseCase {

  private let folderRepository: FolderRepository

  public init(folderRepository: FolderRepository) {
    self.folderRepository = folderRepository
  }

  public func execute() -> BehaviorRelay<FolderList> {
    return folderRepository.bindFolderList()
  }
}
