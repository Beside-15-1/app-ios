import Foundation

import FirebaseAnalytics
import Swinject

import PBAnalyticsInterface

// MARK: - PBAnalyticsAssembly

public final class PBAnalyticsAssembly: Assembly {
  public init() {}

  public func assemble(container: Container) {
    let registerFunctions: [(Container) -> Void] = [
      registerPBAnalytics
    ]

    registerFunctions.forEach { $0(container) }
  }

  private func registerPBAnalytics(container: Container) {
    container.register(PBAnalytics.self) { _ in
      PBAnalyticsImpl(
        firebaseAnalytics: FirebaseAnalytics.Analytics.self
      )
    }
  }
}

// MARK: - Resolver

private extension Resolver {
  func resolve<Service>() -> Service! {
    resolve(Service.self)
  }
}
