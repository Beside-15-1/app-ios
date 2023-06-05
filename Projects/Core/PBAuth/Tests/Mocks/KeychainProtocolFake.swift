//
//  File.swift
//  PBAuthTests
//
//  Created by 박천송 on 2023/05/30.
//

import Foundation

@testable import PBAuth

public final class KeychainProtocolFake: KeychainProtocol {
  var keychain: [String: String] = [:]

  public subscript(key: String) -> String? {
    get {
      keychain[key]
    }
    set {
      keychain[key] = newValue
    }
  }
}
