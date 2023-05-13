//
//  GoogleLoginUseCase.swift
//  Domain
//
//  Created by 박천송 on 2023/05/12.
//

import Foundation

import RxSwift

// MARK: - GoogleLoginUseCase

public protocol GoogleLoginUseCase {
  func excute(access: String) -> Single<String>
}

// MARK: - GoogleLoginUseCaseImpl

public final class GoogleLoginUseCaseImpl: GoogleLoginUseCase {
  private let loginRepository: LoginRepository

  public init(loginRepository: LoginRepository) {
    self.loginRepository = loginRepository
  }

  public func excute(access: String) -> Single<String> {
    loginRepository.requestGoogleLogin(accessToken: access)
  }
}
