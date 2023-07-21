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

  var email: String? {
    get {
      keychain["email"]
    }

    set {
      keychain["email"] = newValue
    }
  }

  var social: String? {
    get {
      keychain["social"]
    }

    set {
      keychain["social"] = newValue
    }
  }
}
