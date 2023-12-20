//
//  PushRepositoryImpl.swift
//  Data
//
//  Created by 박천송 on 10/24/23.
//

import Foundation

import RxSwift

import Domain
import PBNetworking

final class PushRepositoryImpl: PushRepository {

  private let networking: PBNetworking<PushAPI>

  init(networking: PBNetworking<PushAPI>) {
    self.networking = networking
  }

  func updateDeviceID(id: String) -> Single<Void> {
    let target = PushAPI.deviceID(id: id)

    return networking.request(target: target)
      .map { _ in () }
  }

  func fetchSetting() -> Single<NotificationSettingConfig> {
    let target = PushAPI.fetchSetting

    return networking.request(target: target)
      .map(NotificationSettingResponse.self)
      .map { $0.toDomain() }
  }

  func updateSetting(isClassifyAgree: Bool, isReadAgree: Bool) -> Single<Void> {
    let target = PushAPI.updateSetting(isClassifyAgree: isClassifyAgree, isReadAgree: isReadAgree)

    return networking.request(target: target)
      .map { _ in () }
  }
}
