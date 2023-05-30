//
//  LoginRepository.swift
//  Data
//
//  Created by 박천송 on 2023/05/12.
//

import Foundation

import RxSwift

import Domain
import Networking
import PBLog

final class LoginRepositoryImpl: LoginRepository {
  private let provider: PBNetworking<LoginAPI>

  private let disposeBag = DisposeBag()

  init(provider: PBNetworking<LoginAPI>) {
    self.provider = provider
  }

  func requestGoogleLogin(accessToken: String) -> Single<Bool> {
    let target = LoginAPI.google(accessToken)

    return provider.request(target: target)
      .map(TokenResponse.self)
      .map { token in
        return !token.accessToken.isEmpty
      }
  }

  func requestAppleLogin(identity: String) -> Single<Bool> {
    let target = LoginAPI.apple(identity)

    return provider.request(target: target)
      .map(TokenResponse.self)
      .map { token in
        return !token.accessToken.isEmpty
      }
  }
}
