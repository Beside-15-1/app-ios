//
//  TagRepository.swift
//  Domain
//
//  Created by 박천송 on 2023/08/07.
//

import Foundation

import RxSwift

public protocol TagRepository {
  func fetchTagList() -> Single<[Tag]>
  func updateTagList(tagList: [Tag]) -> Single<[Tag]>
  func deleteTag(tag: Tag) -> Single<Void>
  func migration()
}
