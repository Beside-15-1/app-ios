import Foundation

import RxSwift

// MARK: - GoogleLoginUseCase

/// @mockable
public protocol GoogleLoginUseCase {
  func execute(access: String) -> Single<Bool>
}

// MARK: - GoogleLoginUseCaseImpl

public final class GoogleLoginUseCaseImpl: GoogleLoginUseCase {
  private let loginRepository: LoginRepository

  public init(
    loginRepository: LoginRepository
  ) {
    self.loginRepository = loginRepository
  }

  public func execute(access: String) -> Single<Bool> {
    loginRepository.requestGoogleLogin(accessToken: access)
  }
}
