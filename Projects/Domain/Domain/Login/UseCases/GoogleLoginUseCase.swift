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
  private let tagRepository: TagRepository

  public init(
    loginRepository: LoginRepository,
    tagRepository: TagRepository
  ) {
    self.loginRepository = loginRepository
    self.tagRepository = tagRepository
  }

  public func execute(access: String) -> Single<Bool> {
    Single.create { [weak self] single in

      guard let self else {
        single(.failure(RxError.unknown))
        return Disposables.create()
      }

      let task = Task {
        do {
          let canLogin = try await self.loginRepository.requestGoogleLogin(accessToken: access).value

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
