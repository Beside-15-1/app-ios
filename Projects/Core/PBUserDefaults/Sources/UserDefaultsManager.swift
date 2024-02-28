//
//  UserDefaultsManager.swift
//  PBStoreInterface
//
//  Created by 박천송 on 2023/06/29.
//

import Foundation

public class UserDefaultsManager {

  public static var shared = UserDefaultsManager()

  private init() {
    migrateUserDefaultsToAppGroups()
  }

  @UserDefault(key: "tag_list")
  public var tagList: [String] = []

  @UserDefault(key: "email")
  public var email = ""

  @UserDefault(key: "social")
  public var social = ""

  @UserDefault(key: "is_tag_migration")
  public var isTagMigration = false

  func migrateUserDefaultsToAppGroups() {
    // User Defaults - AS-IS
    let defaultDefaults = UserDefaults.standard

    // App Groups Default - TO-BE
    let groupDefaults = UserDefaults(suiteName: "group.pinkboss.joosum")

    // Key to track if we migrated
    let didMigrateToAppGroups = "DidMigrateToAppGroups"

    if let groupDefaults {
      if !groupDefaults.bool(forKey: didMigrateToAppGroups) {
        // UserDefaults.standard 에서 값을 꺼내 App Group UserDefault에 적용하는 로직
        for key in defaultDefaults.dictionaryRepresentation().keys {
          groupDefaults.set(defaultDefaults.dictionaryRepresentation()[key], forKey: key)
        }
        groupDefaults.set(true, forKey: didMigrateToAppGroups)
      } else {}
    }
  }
}
