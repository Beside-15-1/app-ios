//
//  PushAPI.swift
//  Data
//
//  Created by 박천송 on 10/24/23.
//

import Foundation

import Moya
import PBNetworking

enum PushAPI {
  case deviceID(id: String)
  case fetchSetting
  case updateSetting(isClassifyAgree: Bool, isReadAgree: Bool)
}

extension PushAPI: BaseTargetType {

  var path: String {
    switch self {
    case .deviceID:
      return "settings/device"
    case .fetchSetting:
      return "settings/notification"
    case .updateSetting:
      return "settings/notification"
    }
  }

  var method: Moya.Method {
    switch self {
    case .deviceID:
      return .post
    case .fetchSetting:
      return .get
    case .updateSetting:
      return .put
    }
  }

  var task: Moya.Task {
    switch self {
    case .deviceID(let id):
      return .requestJSONEncodable(["deviceId": id])
    case .fetchSetting:
      return .requestPlain
    case .updateSetting(let isClassifyAgree, let isReadAgree):
      return .requestJSONEncodable([
        "isClassifyAgree": isClassifyAgree,
        "isReadAgree": isReadAgree
      ])
    }
  }
}

