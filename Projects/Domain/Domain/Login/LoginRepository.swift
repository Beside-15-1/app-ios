//
//  LoginRepository.swift
//  Domain
//
//  Created by 박천송 on 2023/05/12.
//

import Foundation

import RxSwift

public protocol LoginRepository {
  func requestGoogleLogin(accessToken: String) -> Single<String>
  func requestAppleLogin(identity: String, authorization: String) -> Single<String>
}
