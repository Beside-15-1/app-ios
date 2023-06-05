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
import PBAuthInterface
import PBLog

final class LoginRepositoryImpl: LoginRepository {
  private let provider: PBNetworking<LoginAPI>
  private var keychainDataSource: PBAuthLocalDataSource

  private let disposeBag = DisposeBag()

  init(
    provider: PBNetworking<LoginAPI>,
    keychainDataSource: PBAuthLocalDataSource
  ) {
    self.provider = provider
    self.keychainDataSource = keychainDataSource
  }

  func requestGoogleLogin(accessToken: String) -> Single<Bool> {
    let target = LoginAPI.google(accessToken)

    return provider.request(target: target)
      .map(TokenResponse.self)
      .map { [weak self] token in
        if token.isValid {
          self?.keychainDataSource.accessToken = token.accessToken
          self?.keychainDataSource.refreshToken = token.refreshToken
        }

        return token.isValid
      }
  }

  func requestAppleLogin(identity: String) -> Single<Bool> {
    let target = LoginAPI.apple(identity)

    return provider.request(target: target)
      .map(TokenResponse.self)
      .map { [weak self] token in
        if token.isValid {
          self?.keychainDataSource.accessToken = token.accessToken
          self?.keychainDataSource.refreshToken = token.refreshToken
        }

        return token.isValid
      }
  }

  func logout() -> Single<Bool> {
    keychainDataSource.accessToken = nil
    keychainDataSource.refreshToken = nil

    guard keychainDataSource.accessToken == nil,
          keychainDataSource.refreshToken == nil else {
      return .just(false)
    }

    return .just(true)
  }
}
