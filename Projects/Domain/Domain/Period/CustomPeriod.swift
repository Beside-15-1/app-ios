//
//  CustomPeriod.swift
//  Domain
//
//  Created by 박천송 on 1/11/24.
//

import Foundation

public struct CustomFilter {
  public let periodType: PeriodType
  public let customPeriod: CustomPeriod
  public let selectedTagList: [String]

  public init(periodType: PeriodType, customPeriod: CustomPeriod, selectedTagList: [String]) {
    self.periodType = periodType
    self.customPeriod = customPeriod
    self.selectedTagList = selectedTagList
  }
}

public struct CustomPeriod {
  public let startDate: Date
  public let endDate: Date

  public init() {
    self.startDate = Date(timeIntervalSinceNow: -3600 * 24 * 30)
    self.endDate = Date()
  }

  public init(startDate: Date, endDate: Date) {
    self.startDate = startDate
    self.endDate = endDate
  }
}
