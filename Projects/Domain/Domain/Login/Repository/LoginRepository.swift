//
//  LoginRepository.swift
//  Domain
//
//  Created by 박천송 on 2023/05/12.
//

import Foundation

import RxSwift

/// @mockable
public protocol LoginRepository {
  func requestGoogleLogin(accessToken: String) -> Single<Bool>
  func requestAppleLogin(identity: String) -> Single<Bool>
  func logout() -> Single<Bool>
}
