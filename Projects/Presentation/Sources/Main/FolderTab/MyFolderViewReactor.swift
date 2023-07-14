//
//  MyFolderViewReactor.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/11.
//

import Foundation

import ReactorKit
import RxSwift

final class MyFolderViewReactor: Reactor {

  // MARK: Action & Mutation & State

  enum Action {}

  enum Mutation {}

  struct State {}

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

  func mutate(action: Action) -> Observable<Mutation> {}

  func reduce(state: State, mutation: Mutation) -> State {}
}
