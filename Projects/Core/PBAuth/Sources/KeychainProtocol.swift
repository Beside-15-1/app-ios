import Foundation

import KeychainAccess

// MARK: - KeychainProtocol

protocol KeychainProtocol: AnyObject {
  subscript(key: String) -> String? { get set }
}

// MARK: - Keychain + KeychainProtocol

extension Keychain: KeychainProtocol {}
