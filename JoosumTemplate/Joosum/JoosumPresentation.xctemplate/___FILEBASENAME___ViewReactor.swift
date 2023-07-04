//___FILEHEADER___

import Foundation

import ReactorKit
import RxSwift

enum Action {}

enum Mutation {}

struct State {}


final class ___VARIABLE_sceneName___ViewReactor: Reactor {

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
