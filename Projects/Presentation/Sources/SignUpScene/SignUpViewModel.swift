import Foundation

import RxRelay
import RxSwift

import Domain

// MARK: - SignUpViewModelInput

protocol SignUpViewModelInput {
  var inputNickname: BehaviorRelay<String?> { get }
  var inputAge: BehaviorRelay<String?> { get }
  var inputGender: BehaviorRelay<String?> { get }
  func signUpButtonTapped()
}

// MARK: - SignUpViewModelOutput

protocol SignUpViewModelOutput {
  var isSignUpSuccess: BehaviorRelay<Bool> { get }
  var isButtonEnabled: BehaviorRelay<Bool> { get }
}

// MARK: - SignUpViewModel

final class SignUpViewModel: SignUpViewModelOutput, SignUpViewModelInput {
  // MARK: Properties

  private let accessToken: String
  private let social: String

  private let signUpUseCase: SignUpUseCase

  private let disposeBag = DisposeBag()

  // MARK: initializing

  init(
    signUpUseCase: SignUpUseCase,
    accessToken: String,
    social: String
  ) {
    self.signUpUseCase = signUpUseCase
    self.accessToken = accessToken
    self.social = social

    Observable.combineLatest(inputNickname, inputAge, inputGender) { nickname, age, gender in
      guard let nickname, !nickname.isEmpty,
            let gender, !gender.isEmpty,
            let age, !age.isEmpty else {
        return false
      }
      return true
    }
    .bind(to: isButtonEnabled)
    .disposed(by: disposeBag)
  }

  deinit {
    print("🗑️ deinit: \(type(of: self))")
  }

  // MARK: Input

  var inputNickname: BehaviorRelay<String?> = .init(value: nil)
  var inputAge: BehaviorRelay<String?> = .init(value: nil)
  var inputGender: BehaviorRelay<String?> = .init(value: nil)

  // MARK: Output

  var isSignUpSuccess: BehaviorRelay<Bool> = .init(value: false)
  var isButtonEnabled: BehaviorRelay<Bool> = .init(value: true)
}

// MARK: SignUpViewModelInput

extension SignUpViewModel {
  func signUpButtonTapped() {
    guard let nickName = inputNickname.value,
          let age = Int(inputAge.value ?? "1"),
          let gender = inputAge.value else { return }

    let sex = gender == "남" ? "m" : "w"

    signUpUseCase.excute(
      accessToken: accessToken,
      age: age,
      gender: sex,
      nickname: nickName,
      social: social
    )
    .filter { $0 }
    .asObservable()
    .bind(to: isSignUpSuccess)
    .disposed(by: disposeBag)
  }
}
