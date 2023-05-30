//
//  AppleLoginUseCase.swift
//  Domain
//
//  Created by 박천송 on 2023/05/12.
//

import Foundation

import RxSwift

// MARK: - AppleLoginUseCase

/// @mockable
public protocol AppleLoginUseCase {
  func excute(identity: String) -> Single<Bool>
}

// MARK: - AppleLoginUseCaseImpl

public final class AppleLoginUseCaseImpl: AppleLoginUseCase {
  private let loginRepository: LoginRepository

  public init(loginRepository: LoginRepository) {
    self.loginRepository = loginRepository
  }

  public func excute(identity: String) -> Single<Bool> {
    loginRepository.requestAppleLogin(identity: identity)
  }
}
