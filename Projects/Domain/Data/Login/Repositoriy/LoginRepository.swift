import Foundation

import RxSwift

import Domain
import PBAuthInterface
import PBLog
import PBNetworking

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

  func requestSignUp(
    idToken: String,
    age: Int?,
    gender: String?,
    nickname: String?,
    social: String
  ) -> Single<Bool> {
    let target = LoginAPI.signUp(.init(
      idToken: idToken,
      age: age,
      gender: gender,
      nickname: nickname,
      social: social
    ))
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
}
