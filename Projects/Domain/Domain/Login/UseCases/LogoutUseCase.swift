import Foundation

import RxSwift

// MARK: - LogoutUseCase

/// @mockable
public protocol LogoutUseCase {
  func execute() -> Single<Bool>
}

// MARK: - LogoutUseCaseImpl

public final class LogoutUseCaseImpl: LogoutUseCase {
  private let loginRepository: LoginRepository
  private let tagRepository: TagRepository

  public init(
    loginRepository: LoginRepository,
    tagRepository: TagRepository
  ) {
    self.loginRepository = loginRepository
    self.tagRepository = tagRepository
  }

  public func execute() -> Single<Bool> {
    loginRepository.logout()
  }
}
