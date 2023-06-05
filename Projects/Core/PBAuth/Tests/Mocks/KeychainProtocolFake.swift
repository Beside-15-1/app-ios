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
