//
//  PresentationAssembly.swift
//  Presentation
//
//  Created by Hohyeon Moon on 2023/05/12.
//

import Domain
import Foundation
import PresentationInterface
import Swinject

// MARK: - PresentationAssembly

public final class PresentationAssembly: Assembly {
  public init() {}

  public func assemble(container: Container) {
    let registerFunctions: [(Container) -> Void] = [
      registerLoginBuilder
    ]

    registerFunctions.forEach { $0(container) }
  }

  private func registerLoginBuilder(container: Container) {
    container.register(LoginBuildable.self) { resolver in
      LoginBuilder(dependency: .init(
        loginRepository: resolver.resolve(),
        analytics: resolver.resolve()
      ))
    }
  }
}

// MARK: - Resolver

private extension Resolver {
  func resolve<Service>() -> Service! {
    resolve(Service.self)
  }
}
