//
//  MyPageViewReactor.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/20.
//

import Foundation

import ReactorKit
import RxSwift

import Domain

final class MyPageViewReactor: Reactor {

  // MARK: Action & Mutation & State

  enum Action {
    case logoutButtonTapped
  }

  enum Mutation {
    case setLogoutSuccess
    case setLogoutFailure
  }

  struct State {
    var isLogoutSuccess = false
    @Pulse var isLogoutFailure = false
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State

  private let logoutUseCase: LogoutUseCase


  // MARK: initializing

  init(
    logoutUseCase: LogoutUseCase
  ) {
    defer { _ = self.state }

    self.logoutUseCase = logoutUseCase

    initialState = State()
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }


  // MARK: Mutate & Reduce

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .logoutButtonTapped:
      return logout()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setLogoutSuccess:
      newState.isLogoutSuccess = true

    case .setLogoutFailure:
      newState.isLogoutFailure = true
    }

    return newState
  }
}


// MARK: - Private

extension MyPageViewReactor {

  private func logout() -> Observable<Mutation> {
    logoutUseCase.execute()
      .asObservable()
      .flatMap { isSuccess -> Observable<Mutation> in
        if isSuccess {
          return .just(Mutation.setLogoutSuccess)
        }

        return .just(Mutation.setLogoutFailure)
      }
  }
}
