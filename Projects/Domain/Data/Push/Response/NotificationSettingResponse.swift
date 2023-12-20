//
//  NotificationSettingResponse.swift
//  Domain
//
//  Created by 박천송 on 10/24/23.
//

import Foundation

import Domain

struct NotificationSettingResponse: Codable {
  let isClassifyAgree: Bool
  let isReadAgree: Bool

  func toDomain() -> NotificationSettingConfig {
    .init(isClassifyAgree: isClassifyAgree, isReadAgree: isReadAgree)
  }
}
