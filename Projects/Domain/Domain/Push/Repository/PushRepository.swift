//
//  PushRepository.swift
//  Domain
//
//  Created by 박천송 on 10/24/23.
//

import Foundation

import RxSwift

public protocol PushRepository {
  func updateDeviceID(id: String) -> Single<Void>
  func fetchSetting() -> Single<PushSettingConfig>
  func updateSetting(isClassifyAgree: Bool, isReadAgree: Bool) -> Single<Void>
}
