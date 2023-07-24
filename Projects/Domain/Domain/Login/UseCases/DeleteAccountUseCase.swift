//
//  DeleteAccountUseCase.swift
//  Domain
//
//  Created by 박천송 on 2023/07/24.
//

import Foundation

import RxSwift

public protocol DeleteAccountUseCase {
  func execute() -> Single<Void>
}

public final class DeleteAccountUseCaseImpl: DeleteAccountUseCase {

  private let loginRepository: LoginRepository

  public init(loginRepository: LoginRepository) {
    self.loginRepository = loginRepository
  }

  public func execute() -> Single<Void> {
    loginRepository.deleteAccount()
  }
}
