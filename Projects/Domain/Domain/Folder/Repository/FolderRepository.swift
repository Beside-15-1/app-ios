//
//  FolderRepository.swift
//  Domain
//
//  Created by 박천송 on 2023/07/07.
//

import Foundation

import RxSwift

public protocol FolderRepository {
  func fetchFolderList(sort: String) -> Single<FolderList>

  func getFolderList() -> FolderList

  func createFolder(
    backgroundColor: String,
    title: String,
    titleColor: String,
    illustration: String?
  ) -> Single<Folder>

  func updateFolder(
    id: String,
    backgroundColor: String,
    title: String,
    titleColor: String,
    illustration: String?
  ) -> Single<Folder>

  func deleteFolder(id: String) -> Single<Void>
}
