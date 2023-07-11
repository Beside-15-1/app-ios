//
//  CreateFolderUseCase.swift
//  Domain
//
//  Created by 박천송 on 2023/07/07.
//

import Foundation

import RxSwift

public protocol CreateFolderUseCase {
  func execute(
    backgroundColor: String,
    title: String,
    titleColor: String,
    illustration: String?
  ) -> Single<Void>
}

public class CreateFolderUseCaseImpl: CreateFolderUseCase {

  private let folderRepository: FolderRepository

  public init(folderRepository: FolderRepository) {
    self.folderRepository = folderRepository
  }

  public func execute(
    backgroundColor: String,
    title: String,
    titleColor: String,
    illustration: String?
  ) -> Single<Void> {
    folderRepository.createFolder(
      backgroundColor: backgroundColor,
      title: title,
      titleColor: titleColor,
      illustration: illustration
    )
  }
}
