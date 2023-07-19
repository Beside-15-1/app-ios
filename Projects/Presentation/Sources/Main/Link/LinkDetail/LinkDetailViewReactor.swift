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

  enum Action {}

  enum Mutation {}

  struct State {
    var link: Link
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State


  // MARK: initializing

  init(
    link: Link
  ) {
    defer { _ = self.state }

    self.initialState = State(
      link: link
    )
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }


  // MARK: Mutate & Reduce

  func mutate(action: Action) -> Observable<Mutation> {}

  func reduce(state: State, mutation: Mutation) -> State {}
}
