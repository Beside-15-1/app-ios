//
//  UserDefaultsMacro.swift
//  PBStoreInterface
//
//  Created by 박천송 on 2023/06/29.
//

import Foundation

@propertyWrapper
public class UserDefault<Value> {

  public var wrappedValue: Value {
    get {
      userDefaults.object(forKey: key) as? Value ?? defaultValue
    }

    set {
      userDefaults.setValue(newValue, forKey: key)
    }
  }

  var defaultValue: Value
  var key: String

  private let userDefaults = UserDefaults.standard

  public init(
    wrappedValue defaultValue: Value,
    key: String
  ) {
    self.defaultValue = defaultValue
    self.key = key
  }
}
