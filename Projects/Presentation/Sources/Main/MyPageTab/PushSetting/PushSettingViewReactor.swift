//
//  PushSettingViewReactor.swift
//  Presentation
//
//  Created by 박천송 on 10/24/23.
//

import Foundation

import ReactorKit
import RxSwift

import Domain

final class PushSettingViewReactor: Reactor {

  // MARK: Action & Mutation & State

  enum Action {}

  enum Mutation {}

  struct State {}

  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State

  private let pushRepository: PushRepository


  // MARK: initializing

  init(
    pushRepository: PushRepository
  ) {
    defer { _ = self.state }

    self.pushRepository = pushRepository
    
    initialState = State()
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }


  // MARK: Mutate & Reduce

  func mutate(action: Action) -> Observable<Mutation> {}

  func reduce(state: State, mutation: Mutation) -> State {}
}
