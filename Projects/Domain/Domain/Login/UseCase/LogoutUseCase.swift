//
//  LogoutUseCase.swift
//  Domain
//
//  Created by 박천송 on 2023/05/30.
//

import Foundation

import RxSwift

// MARK: - LogoutUseCase

/// @mockable
public protocol LogoutUseCase {
  func excute() -> Single<Bool>
}

// MARK: - LogoutUseCaseImpl

public final class LogoutUseCaseImpl: LogoutUseCase {
  private let loginRepository: LoginRepository

  public init(loginRepository: LoginRepository) {
    self.loginRepository = loginRepository
  }

  public func excute() -> Single<Bool> {
    loginRepository.logout()
  }
}
