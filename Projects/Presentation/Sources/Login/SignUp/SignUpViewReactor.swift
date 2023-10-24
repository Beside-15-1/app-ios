import Foundation

import ReactorKit
import RxRelay
import RxSwift

import Domain
import PBAnalyticsInterface

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

    var isSucceed = false
    @Pulse var error: Error?
  }


  // MARK: Properties

  private let disposeBag = DisposeBag()

  let initialState: State

  private let analytics: PBAnalytics


  // MARK: UseCase

  private let signUpUseCase: SignUpUseCase


  // MARK: initializing

  init(
    analytics: PBAnalytics,
    signUpUseCase: SignUpUseCase,
    accessToken: String,
    social: String
  ) {
    defer { _ = self.state }

    self.analytics = analytics
    self.signUpUseCase = signUpUseCase

    self.initialState = State(
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
      switch gender {
      case "w":
        analytics.log(type: SignUpEvent.click(component: .female))
      case "m":
        analytics.log(type: SignUpEvent.click(component: .male))
      case "etc":
        analytics.log(type: SignUpEvent.click(component: .etc))
      default:
        break
      }

      return .just(Mutation.setGender(gender))

    case .selectYear(let year):
      analytics.log(type: SignUpEvent.click(component: .birthyear))
      return .just(Mutation.setYear(year))

    case .completeButtonTapped:
      analytics.log(type: SignUpEvent.click(component: .next))
      return signUp()

    case .passButtonTapped:
      analytics.log(type: SignUpEvent.click(component: .skip))
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
    signUpUseCase.execute(
      idToken: currentState.accessToken,
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
    signUpUseCase.execute(
      idToken: currentState.accessToken,
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

