//
//  LinkDetailViewReactor.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/18.
//

import Foundation

import ReactorKit
import RxSwift

import Domain

final class LinkDetailViewReactor: Reactor {

  // MARK: Action & Mutation & State

  enum Action {
    case deleteButtonTapped
  }

  enum Mutation {
    case setDeleted
  }

  struct State {
    var link: Link

    var isDeleted = false
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State

  private let deleteLinkUseCase: DeleteLinkUseCase


  // MARK: initializing

  init(
    deleteLinkUseCase: DeleteLinkUseCase,
    link: Link
  ) {
    defer { _ = self.state }

    self.deleteLinkUseCase = deleteLinkUseCase

    self.initialState = State(
      link: link
    )
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }


  // MARK: Mutate & Reduce

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .deleteButtonTapped:
      return deleteLink()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setDeleted:
      newState.isDeleted = true
    }

    return newState
  }
}


// MARK: - Private

extension LinkDetailViewReactor {

  private func deleteLink() -> Observable<Mutation> {
    deleteLinkUseCase.execute(id: currentState.link.id)
      .asObservable()
      .flatMap { _ -> Observable<Mutation> in
        .just(Mutation.setDeleted)
      }
  }
}
