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
    case completeButtonTapped
    case passButtonTapped
  }

  enum Mutation {
    case setGender(String)
    case setYear(Int)
    case setSucceed
    case setError(Error)
  }

  struct State {
    let accessToken: String
    let social: String
    var gender: String?
    var year: Int?

    var isCompleteButtonisEnabled: Bool {
      if gender != nil {
        return true
      }

      if year != nil {
        return true
      }

      return false
    }

    var isSucceed: Bool = false
    @Pulse var error: Error?
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

    case .completeButtonTapped:
      return signUp()

    case .passButtonTapped:
      return pass()
    }
  }

  func reduce(state: State, mutation: Mutation) -> State {
    var newState = state

    switch mutation {
    case .setGender(let gender):
      newState.gender = gender

    case .setYear(let year):
      newState.year = year

    case .setSucceed:
      newState.isSucceed = true

    case .setError(let error):
      newState.error = error
    }

    return newState
  }
}


// MARK: - Private

extension SignUpViewReactor {

  private func signUp() -> Observable<Mutation> {
    signUpUseCase.excute(
      accessToken: currentState.accessToken,
      age: currentState.year,
      gender: currentState.gender,
      nickname: nil,
      social: currentState.social
    )
    .asObservable()
    .flatMap { isSuccess -> Observable<Mutation> in

      if isSuccess {
        return .just(Mutation.setSucceed)
      } else {
        return .just(Mutation.setError(RxError.unknown))
      }
    }
    .catch {
      .just(Mutation.setError($0))
    }
  }

  private func pass() -> Observable<Mutation> {
    signUpUseCase.excute(
      accessToken: currentState.accessToken,
      age: nil,
      gender: nil,
      nickname: nil,
      social: currentState.social
    )
    .asObservable()
    .flatMap { isSuccess -> Observable<Mutation> in

      if isSuccess {
        return .just(Mutation.setSucceed)
      } else {
        return .just(Mutation.setError(RxError.unknown))
      }
    }
    .catch {
      .just(Mutation.setError($0))
    }
  }
}

