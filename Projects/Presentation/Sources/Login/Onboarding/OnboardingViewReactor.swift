//
//  OnboardingViewReactor.swift
//  Presentation
//
//  Created by 박천송 on 2023/08/07.
//

import Foundation

import ReactorKit
import RxSwift

import PBAnalyticsInterface

final class OnboardingViewReactor: Reactor {

  // MARK: Action & Mutation & State

  enum Action {
    case buttonTapped
  }

  enum Mutation {
    case setType(OnboardingType)
    case routeToMain
  }

  struct State {
    var type: OnboardingType = .first
    var shouldRouteMain = false
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State

  private let analytics: PBAnalytics

  // MARK: initializing

  init(
    analytics: PBAnalytics
  ) {
    defer { _ = self.state }
    self.analytics = analytics
    self.initialState = State()
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }


  // MARK: Mutate & Reduce

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .buttonTapped:

      switch currentState.type {
      case .first:
        analytics.log(type: OnboardingAddLinkEvent.click(component: .next))
        return .just(Mutation.setType(.second))
      case .second:
        analytics.log(type: OnboardingFolderEvent.click(component: .next))
        return .just(Mutation.setType(.third))
      case .third:
        analytics.log(type: OnboardingTagEvent.click(component: .startApp))
        return .just(Mutation.routeToMain)
      }
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setType(let type):
      newState.type = type

    case .routeToMain:
      newState.shouldRouteMain = true
    }

    return newState
  }
}
