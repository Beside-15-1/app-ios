//
//  OnboardingViewReactor.swift
//  Presentation
//
//  Created by 박천송 on 2023/08/07.
//

import Foundation

import ReactorKit
import RxSwift

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


  // MARK: initializing

  init() {
    defer { _ = self.state }
    initialState = State()
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
        return .just(Mutation.setType(.second))
      case .second:
        return .just(Mutation.setType(.third))
      case .third:
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
