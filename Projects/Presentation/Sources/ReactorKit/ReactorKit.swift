//
//  ReactorKit.swift
//  Presentation
//
//  Created by 박천송 on 2023/04/25.
//

import Foundation

import ReactorKit

class ReactorKit: Reactor {
  enum Action {
    case plusButtonTapped
    case minusButtonTapped
  }

  enum Mutation {
    case setText(String)
  }

  struct State {
    var text = "0"
  }

  
  // MARK: Properties

  let initialState: State


  // MARK: initializing

  init() {
    defer { _ = self.state }
    self.initialState = State()
  }


  // MARK: Mutate & Reduce
  // 비즈니스 로직이 구현되는 부분이에요
  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .plusButtonTapped:
      let number = Int(currentState.text) ?? 0

      return .just(Mutation.setText(String(number + 1)))

    case .minusButtonTapped:
      let number = Int(currentState.text) ?? 0

      return .just(Mutation.setText(String(number - 1)))
    }
  }

  // 상태를 바꿔주는 부분이에요 해당 상태를 뷰에서 바인딩해요
  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setText(let text):
      newState.text = text
    }

    return newState
  }
}
