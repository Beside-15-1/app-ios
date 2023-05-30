//
//  RequsetLogoutUseCase.swift
//  Domain
//
//  Created by 박천송 on 2023/05/30.
//

import Foundation

import RxSwift

// MARK: - RequsetLogoutUseCase

/// @mockable
public protocol RequsetLogoutUseCase {
  func excute() -> Single<Bool>
}

// MARK: - RequsetLogoutUseCaseImpl

public final class RequsetLogoutUseCaseImpl: RequsetLogoutUseCase {
  private let loginRepository: LoginRepository

  public init(loginRepository: LoginRepository) {
    self.loginRepository = loginRepository
  }

  public func excute() -> Single<Bool> {
    loginRepository.logout()
  }
}
