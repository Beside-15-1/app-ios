import Foundation

import RxSwift

/// @mockable
public protocol LoginRepository {
  func requestGoogleLogin(accessToken: String) -> Single<Bool>
  func requestAppleLogin(identity: String) -> Single<Bool>
  func logout() -> Single<Bool>
  func requestSignUp(
    accessToken: String,
    age: Int?,
    gender: String?,
    nickname: String?,
    social: String
  ) -> Single<Bool>
}
