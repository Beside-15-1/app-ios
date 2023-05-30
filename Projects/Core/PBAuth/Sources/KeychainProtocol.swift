//
//  KeychainProtocol.swift
//  PBAuth
//
//  Created by 박천송 on 2023/05/30.
//

import Foundation

import KeychainAccess

// MARK: - KeychainProtocol

protocol KeychainProtocol: AnyObject {
  subscript(key: String) -> String? { get set }
}

// MARK: - Keychain + KeychainProtocol

extension Keychain: KeychainProtocol {}
