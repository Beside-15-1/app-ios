import Foundation

import RxRelay
import RxSwift
import ReactorKit

import Domain

final class SignUpViewReactor: Reactor {

  // MARK: Action & Mutation & State

  enum Action {}

  enum Mutation {}

  struct State {
    let accessToken: String
    let social: String
  }


  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State


  // MARK: UseCase

  private let signUpUseCase: SignUpUseCase


  // MARK: initializing

  init(
    signUpUseCase: SignUpUseCase,
    accessToken: String,
    social: String
  ) {
    defer { _ = self.state }

    self.signUpUseCase = signUpUseCase

    initialState = State(
      accessToken: accessToken,
      social: social
    )
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }


  // MARK: Mutate & Reduce

  func mutate(action: Action) -> Observable<Mutation> {}

  func reduce(state: State, mutation: Mutation) -> State {}
}
