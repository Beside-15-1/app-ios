//
//  UserDefaultsManager.swift
//  PBStoreInterface
//
//  Created by 박천송 on 2023/06/29.
//

import Foundation

public class UserDefaultsManager {

  public static var shared = UserDefaultsManager()

  private init() {}

  @UserDefault(key: "tag_list")
  public var tagList: [String] = []

  @UserDefault(key: "email")
  public var email: String = ""

  @UserDefault(key: "social")
  public var social: String = ""
}
