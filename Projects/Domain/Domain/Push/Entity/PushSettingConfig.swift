//
//  PushSettingConfig.swift
//  Domain
//
//  Created by 박천송 on 10/24/23.
//

import Foundation

public struct PushSettingConfig: Hashable {

  public let isClassifyAgree: Bool
  public let isReadAgree: Bool

  public init(isClassifyAgree: Bool, isReadAgree: Bool) {
    self.isClassifyAgree = isClassifyAgree
    self.isReadAgree = isReadAgree
  }
}

