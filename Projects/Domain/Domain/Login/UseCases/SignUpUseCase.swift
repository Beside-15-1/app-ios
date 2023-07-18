import Foundation

import RxSwift

// MARK: - SignUpUseCase

/// @mockable
public protocol SignUpUseCase {
  func execute(
    idToken: String,
    age: Int?,
    gender: String?,
    nickname: String?,
    social: String
  ) -> Single<Bool>
}

// MARK: - SignUpUseCaseImpl

public final class SignUpUseCaseImpl: SignUpUseCase {
  private let loginRepository: LoginRepository

  public init(loginRepository: LoginRepository) {
    self.loginRepository = loginRepository
  }

  public func execute(
    idToken: String,
    age: Int?,
    gender: String?,
    nickname: String?,
    social: String
  ) -> Single<Bool> {
    loginRepository.requestSignUp(
      idToken: idToken,
      age: age,
      gender: gender,
      nickname: nickname,
      social: social
    )
  }
}
