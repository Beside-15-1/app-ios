import Foundation

import ReactorKit
import RxSwift

final class CreateLinkViewReactor: Reactor {
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

  func mutate(action: Action) -> Observable<Mutation> {}

  func reduce(state: State, mutation: Mutation) -> State {}
}
