//
//  GetMeUseCase.swift
//  Domain
//
//  Created by 박천송 on 2023/07/21.
//

import Foundation

import RxSwift

public protocol GetMeUseCase {
  func execute() -> Single<Void>
}

public final class GetMeUsecaseImpl: GetMeUseCase {

  private let loginRepository: LoginRepository

  public init(loginRepository: LoginRepository) {
    self.loginRepository = loginRepository
  }

  public func execute() -> Single<Void> {
    loginRepository.getMe()
  }
}
