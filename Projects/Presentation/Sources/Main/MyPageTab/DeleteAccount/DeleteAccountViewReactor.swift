//
//  DeleteAccountViewReactor.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/22.
//

import Foundation

import ReactorKit
import RxSwift

import PresentationInterface
import Domain

final class DeleteAccountViewReactor: Reactor {

  // MARK: Action & Mutation & State

  enum Action {
    case check(Bool)
    case deleteAccountButtonTapped
  }

  enum Mutation {
    case setCheck(Bool)
    case setSucceed
  }

  struct State {
    var isCheck = false

    var isDeleteButtonEnabled: Bool {
      isCheck
    }

    var isUseButtonEnabled: Bool {
      !isCheck
    }

    var isSucceed = false
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State

  private let deleteAccountUseCase: DeleteAccountUseCase


  // MARK: initializing

  init(
    deleteAccountUseCase: DeleteAccountUseCase
  ) {
    defer { _ = self.state }

    self.deleteAccountUseCase = deleteAccountUseCase

    self.initialState = State()
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }


  // MARK: Mutate & Reduce

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .check(let isCheck):
      return .just(Mutation.setCheck(isCheck))

    case .deleteAccountButtonTapped:
      return deleteAccount()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setCheck(let isCheck):
      newState.isCheck = isCheck

    case .setSucceed:
      newState.isSucceed = true
    }

    return newState
  }
}


// MARK: - Private

extension DeleteAccountViewReactor {

  private func deleteAccount() -> Observable<Mutation> {
    deleteAccountUseCase.execute()
      .asObservable()
      .flatMap { _ -> Observable<Mutation> in
        return .just(Mutation.setSucceed)
      }
  }
}
