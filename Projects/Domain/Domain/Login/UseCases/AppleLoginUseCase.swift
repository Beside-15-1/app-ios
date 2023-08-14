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
  private let tagRepository: TagRepository

  public init(
    loginRepository: LoginRepository,
    tagRepository: TagRepository
  ) {
    self.loginRepository = loginRepository
    self.tagRepository = tagRepository
  }

  public func execute(identity: String) -> Single<Bool> {
    Single.create { [weak self] single in

      guard let self else {
        single(.failure(RxError.unknown))
        return Disposables.create()
      }

      let task = Task {
        do {
          let canLogin = try await self.loginRepository.requestAppleLogin(identity: identity).value

          if canLogin {
            try await self.tagRepository.fetchTagList().value
          }

          single(.success(canLogin))
        } catch {
          single(.failure(RxError.unknown))
        }
      }

      return Disposables.create {
        task.cancel()
      }
    }
    .observe(on: MainScheduler.instance)
  }
}
