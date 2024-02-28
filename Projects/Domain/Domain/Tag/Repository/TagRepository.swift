//
//  TagRepository.swift
//  Domain
//
//  Created by 박천송 on 2023/08/07.
//

import Foundation

import RxSwift

public protocol TagRepository {
  func fetchTagList() -> Single<Void>
  func updateTagList() -> Single<Void>
  func deleteTag(tag: String) -> Single<Void>
}
