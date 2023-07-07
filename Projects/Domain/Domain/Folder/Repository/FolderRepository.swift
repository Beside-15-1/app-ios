//
//  FolderRepository.swift
//  Domain
//
//  Created by 박천송 on 2023/07/07.
//

import Foundation

import RxSwift

public protocol FolderRepository {
  func fetchFolderList(sort: String) -> Single<[Folder]>

  func createFolder(
    backgroundColor: String,
    title: String,
    titleColor: String,
    illustration: String?
  ) -> Single<Void>
}
