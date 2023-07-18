//
//  LinkSortViewReactor.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/18.
//

import Foundation

import ReactorKit
import RxSwift

import Domain

final class LinkSortViewReactor: Reactor {

  // MARK: Action & Mutation & State

  enum Action {}

  enum Mutation {}

  struct State {
    let sortType: LinkSortingType
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State


  // MARK: initializing

  init(
    sortType: LinkSortingType
  ) {
    defer { _ = self.state }
    self.initialState = State(
      sortType: sortType
    )
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }


  // MARK: Mutate & Reduce

  func mutate(action: Action) -> Observable<Mutation> {}

  func reduce(state: State, mutation: Mutation) -> State {}
}
