//
//  PBAuthLocalDataSourceImpl.swift
//  PBAuth
//
//  Created by 박천송 on 2023/05/30.
//

import Foundation

import PBAuthInterface

// MARK: - PBAuthLocalDataSourceImpl

final class PBAuthLocalDataSourceImpl: PBAuthLocalDataSource {
  let keychain: KeychainProtocol

  init(keychain: KeychainProtocol) {
    self.keychain = keychain
  }

  var accessToken: String? {
    get {
      keychain["accessToken"]
    }

    set {
      keychain["accessToken"] = newValue
    }
  }

  var refreshToken: String? {
    get {
      keychain["refreshToken"]
    }

    set {
      keychain["refreshToken"] = newValue
    }
  }
}
