import Foundation

import KeychainAccess
import Swinject

import Domain
import PBAuthInterface
import PBNetworking
import PBUserDefaults

// MARK: - DataAssembly

public final class DataAssembly: Assembly {
  public init() {}

  public func assemble(container: Container) {
    let registerFunctions: [(Container) -> Void] = [
      registerLoginRepository,
      registerFolderRepository,
      registerLinkRepository,
      registerTagRepository,
    ]

    registerFunctions.forEach { $0(container) }
  }

  private func registerLoginRepository(container: Container) {
    container.register(LoginRepository.self) { resolver in
      LoginRepositoryImpl(
        provider: .init(
          keychain: Keychain(service: "com.pinkboss.joosum")
        ),
        keychainDataSource: resolver.resolve(PBAuthLocalDataSource.self)!
      )
    }
  }

  private func registerFolderRepository(container: Container) {
    container.register(FolderRepository.self) { resolver in
      FolderRepositoryImpl(
        networking: .init(
          keychain: Keychain(service: "com.pinkboss.joosum")
        )
      )
    }
  }

  private func registerLinkRepository(container: Container) {
    container.register(LinkRepository.self) { resolver in
      LinkRepositoryImpl(
        networking: .init(
          keychain: Keychain(service: "com.pinkboss.joosum")
        )
      )
    }
  }

  private func registerTagRepository(container: Container) {
    container.register(TagRepository.self) { r in
      TagRepositoryImpl(
        networking: .init(
          keychain: Keychain(service: "com.pinkboss.joosum")
        )
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
