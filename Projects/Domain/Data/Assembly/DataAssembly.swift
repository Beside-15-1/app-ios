//
//  DataAssembly.swift
//  Data
//
//  Created by 박천송 on 2023/04/27.
//

import Foundation

import Swinject

import Domain
import PBAuthInterface
import PBNetworking

// MARK: - DataAssembly

public final class DataAssembly: Assembly {
  public init() {}

  public func assemble(container: Container) {
    let registerFunctions: [(Container) -> Void] = [
      registerLoginRepository
    ]

    registerFunctions.forEach { $0(container) }
  }

  private func registerLoginRepository(container: Container) {
    container.register(LoginRepository.self) { resolver in
      LoginRepositoryImpl(
        provider: .init(),
        keychainDataSource: resolver.resolve(PBAuthLocalDataSource.self)!
      )
    }
  }
}

// MARK: - Resolver

extension Resolver {
  private func resolve<Service>() -> Service! {
    resolve(Service.self)
  }
}
