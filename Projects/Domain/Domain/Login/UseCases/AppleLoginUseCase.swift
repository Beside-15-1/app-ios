import Foundation

import RxSwift

// MARK: - AppleLoginUseCase

/// @mockable
public protocol AppleLoginUseCase {
  func execute(identity: String) -> Single<Bool>
}

// MARK: - AppleLoginUseCaseImpl

public final class AppleLoginUseCaseImpl: AppleLoginUseCase {
  private let loginRepository: LoginRepository

  public init(loginRepository: LoginRepository) {
    self.loginRepository = loginRepository
  }

  public func execute(identity: String) -> Single<Bool> {
    loginRepository.requestAppleLogin(identity: identity)
  }
}
