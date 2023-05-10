//
//  JSAnalyticsAssembly.swift
//  JSAnalytics
//
//  Created by 박천송 on 2023/05/10.
//

import Foundation

import FirebaseAnalytics
import Swinject

import JSAnalyticsInterface

// MARK: - JSAnalyticsAssembly

public final class JSAnalyticsAssembly: Assembly {
  public init() {}

  public func assemble(container: Container) {
    let registerFunctions: [(Container) -> Void] = [
      registerJSAnalytics
    ]

    registerFunctions.forEach { $0(container) }
  }

  private func registerJSAnalytics(container: Container) {
    container.register(JSAnalytics.self) { _ in
      JSAnalyticsImpl(
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
