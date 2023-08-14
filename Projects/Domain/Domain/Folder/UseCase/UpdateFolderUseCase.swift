//
//  UpdateFolderUseCase.swift
//  Domain
//
//  Created by 박천송 on 2023/07/07.
//

import Foundation

import RxSwift

public protocol UpdateFolderUseCase {
  func execute(
    id: String,
    backgroundColor: String,
    title: String,
    titleColor: String,
    illustration: String?
  ) -> Single<Folder>
}

public class UpdateFolderUseCaseImpl: UpdateFolderUseCase {

  private let folderRepository: FolderRepository

  public init(folderRepository: FolderRepository) {
    self.folderRepository = folderRepository
  }

  public func execute(
    id: String,
    backgroundColor: String,
    title: String,
    titleColor: String,
    illustration: String?
  ) -> Single<Folder> {
    folderRepository.updateFolder(
      id: id,
      backgroundColor: backgroundColor,
      title: title,
      titleColor: titleColor,
      illustration: illustration
    )
  }
}
