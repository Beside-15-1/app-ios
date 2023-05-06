//
//  DomainAssembly.swift
//  Data
//
//  Created by 박천송 on 2023/04/27.
//

import Foundation

import Swinject

import Domain
import PresentationInterface

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
    container.register(LoginBuildable.self) { r in
      LoginBuilder(dependency: .init(guideRepository: r.resolve()))
    }
  }
}

// MARK: - Resolver

private extension Resolver {
  func resolve<Service>() -> Service! {
    resolve(Service.self)
  }
}
