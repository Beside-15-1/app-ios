import Foundation

import ReactorKit
import RxSwift

final class CreateLinkViewModel: Reactor {
  enum Action {}

  enum Mutate {}

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

  func mutate(action: Action) -> Observable<Action> {}

  func reduce(state: State, mutation: Action) -> State {}
}
