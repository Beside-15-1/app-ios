//
//  UserDefaultsRepository.swift
//  PBStoreInterface
//
//  Created by 박천송 on 2023/06/29.
//

import Foundation

public class UserDefaultsRepository {

  @UserDefault(key: "tag_list")
  public var tagList: [String] = []

  public init() {}
}
