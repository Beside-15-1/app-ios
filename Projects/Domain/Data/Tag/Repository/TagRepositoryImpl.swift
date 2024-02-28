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

  init(networking: PBNetworking<TagAPI>) {
    self.networking = networking
  }

  func fetchTagList() -> Single<Void> {
    let target = TagAPI.fetchTagList

    return networking.request(target: target)
      .map([String].self)
      .catchAndReturn([])
      .map { tagList in
        UserDefaultsManager.shared.tagList = tagList
      }
  }

  func updateTagList() -> Single<Void> {
    let target = TagAPI.updateTagList(UserDefaultsManager.shared.tagList)

    return networking.request(target: target)
      .map { _ in
        UserDefaultsManager.shared.tagList = []
      }
  }

  func deleteTag(tag: String) -> Single<Void> {
    let target = TagAPI.deleteTag(tag)

    return networking.request(target: target)
      .map { _ in Void() }
  }
}
