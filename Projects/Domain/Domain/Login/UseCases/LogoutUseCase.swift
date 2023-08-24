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
    tagRepository.updateTagList()
      .flatMap { [weak self] _ -> Single<Bool> in
        guard let self else { return .error(RxError.unknown)}

        return self.loginRepository.logout()
      }
  }
}
