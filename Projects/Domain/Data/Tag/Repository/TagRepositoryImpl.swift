//
//  TagRepositoryImpl.swift
//  Data
//
//  Created by 박천송 on 2023/08/07.
//

import Foundation

import RxSwift

import Domain
import PBNetworking
import PBUserDefaults

final class TagRepositoryImpl: TagRepository {

  private let networking: PBNetworking<TagAPI>
  private let disposeBag = DisposeBag()

  init(networking: PBNetworking<TagAPI>) {
    self.networking = networking
  }

  func fetchTagList() -> Single<[Tag]> {
    let target = TagAPI.fetchTagList

    return networking.request(target: target)
      .map([String].self)
      .catchAndReturn([])
  }

  func updateTagList(tagList: [Tag]) -> Single<[Tag]> {
    let target = TagAPI.updateTagList(tagList)

    return networking.request(target: target)
      .map([String].self)
  }

  func deleteTag(tag: Tag) -> Single<Void> {
    let target = TagAPI.deleteTag(tag)

    return networking.request(target: target)
      .map { _ in Void() }
  }

  // Local -> Remote 데이터 동기화를 위한 마이그레이션 함수 <2024.02.28>
  func migration() {
    if !UserDefaultsManager.shared.isTagMigration {
      let target = TagAPI.updateTagList(UserDefaultsManager.shared.tagList)

      return networking.request(target: target)
        .subscribe(onSuccess: { _ in
          UserDefaultsManager.shared.isTagMigration = true
        })
        .disposed(by: disposeBag)
    }
  }
}
