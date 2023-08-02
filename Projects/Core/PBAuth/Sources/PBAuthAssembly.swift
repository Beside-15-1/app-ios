import Foundation

import Swinject

import KeychainAccess
import PBAuthInterface

// MARK: - PBAuthAssembly

public final class PBAuthAssembly: Assembly {
  public init() {}

  public func assemble(container: Container) {
    let registerFunctions: [(Container) -> Void] = [
      registerPBAuthLocalDataSource
    ]

    registerFunctions.forEach { $0(container) }
  }

  private func registerPBAuthLocalDataSource(container: Container) {
    container.register(PBAuthLocalDataSource.self) { _ in
      PBAuthLocalDataSourceImpl(
        keychain: Keychain(service: "com.pinkboss.joosum")
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
