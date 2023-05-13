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

final class LoginRepositoryImpl: LoginRepository {
  private let provider: JSNetworking<LoginAPI>

  private let disposeBag = DisposeBag()

  init(provider: JSNetworking<LoginAPI>) {
    self.provider = provider
  }

  func requestGoogleLogin(accessToken: String) -> Single<String> {
    let target = LoginAPI.google(accessToken)

    return provider.request(target: target)
      .flatMap {
        .just(String(data: $0.data, encoding: .utf8) ?? "")
      }
  }

  func requestAppleLogin(identity: String, authorization: String) -> Single<String> {
    let target = LoginAPI.apple(identity: identity, authorization: authorization)

    return provider.request(target: target)
      .flatMap {
        .just(String(data: $0.data, encoding: .utf8) ?? "")
      }
  }
}
