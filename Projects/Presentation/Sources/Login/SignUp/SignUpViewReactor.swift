import Foundation

import RxRelay
import RxSwift
import ReactorKit

import Domain

final class SignUpViewReactor: Reactor {

  // MARK: Action & Mutation & State

  enum Action {
    case genderButtonTapped(String)
    case selectYear(Int)
  }

  enum Mutation {
    case setGender(String)
    case setYear(Int)
  }

  struct State {
    let accessToken: String
    let social: String
    var gender: String?
    var year: Int?

    var isCompleteButtonisEnabled: Bool {
      if let gender {
        return true
      }

      if let year {
        return true
      }
      
      return false
    }
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

  func mutate(action: Action) -> Observable<Mutation> {
    switch action {
    case .genderButtonTapped(let gender):
      return .just(Mutation.setGender(gender))

    case .selectYear(let year):
      return .just(Mutation.setYear(year))
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setGender(let gender):
      newState.gender = gender

    case .setYear(let year):
      newState.year = year
    }

    return newState
  }
}
