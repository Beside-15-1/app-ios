//
//  FolderSortViewReactor.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/16.
//

import Foundation

import ReactorKit
import RxSwift

import PresentationInterface

final class FolderSortViewReactor: Reactor {

  // MARK: Action & Mutation & State

  enum Action {}

  enum Mutation {}

  struct State {
    let sortType: FolderSortModel
  }

  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State


  // MARK: initializing

  init(
    sortType: FolderSortModel
  ) {
    defer { _ = self.state }
    initialState = State(
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
