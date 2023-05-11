//
//  LoginAssembly.swift
//  LoginManager
//
//  Created by 박천송 on 2023/05/04.
//

import Foundation

import Swinject

import LoginManagerInterface

// MARK: - LoginAssembly

public final class LoginAssembly: Assembly {
  public init() {}

  public func assemble(container: Container) {
    let registerFunctions: [(Container) -> Void] = [
      registerLoginManager
    ]

    registerFunctions.forEach { $0(container) }
  }

  private func registerLoginManager(container: Container) {
    container.register(LoginManager.self) { _ in
      LoginManagerImpl()
    }
  }
}

// MARK: - Resolver

private extension Resolver {
  func resolve<Service>() -> Service! {
    resolve(Service.self)
  }
}
