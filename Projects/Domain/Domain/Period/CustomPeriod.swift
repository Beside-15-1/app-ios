//
//  CustomPeriod.swift
//  Domain
//
//  Created by 박천송 on 1/11/24.
//

import Foundation

public struct CustomFilter: Hashable {
  public var isUnreadFiltering: Bool
  public var periodType: PeriodType
  public var customPeriod: CustomPeriod
  public var selectedTagList: [String]

  public init() {
    self.isUnreadFiltering = false
    self.periodType = .all
    self.customPeriod = CustomPeriod()
    self.selectedTagList = []
  }

  public init(
    isUnreadFiltering: Bool,
    periodType: PeriodType,
    customPeriod: CustomPeriod,
    selectedTagList: [String]
  ) {
    self.isUnreadFiltering = isUnreadFiltering
    self.periodType = periodType
    self.customPeriod = customPeriod
    self.selectedTagList = selectedTagList
  }
}

public struct CustomPeriod: Hashable {
  public let startDate: Date
  public let endDate: Date

  public init() {
    let startDate = Date(timeIntervalSinceNow: -3600 * 24 * 30)
    let endDate = Date()

    let calendar = Calendar.current
    let startOfStartDate = calendar.startOfDay(for: startDate)

    // endDate를 일 기준으로 23:59:59로 설정
    let endOfEndDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate)!

    self.startDate = startOfStartDate
    self.endDate = endOfEndDate
  }

  public init(startDate: Date, endDate: Date) {
    // startDate를 일 기준으로 00:00:00으로 설정
    let calendar = Calendar.current
    let startOfStartDate = calendar.startOfDay(for: startDate)

    // endDate를 일 기준으로 23:59:59로 설정
    let endOfEndDate = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: endDate)!

    self.startDate = startOfStartDate
    self.endDate = endOfEndDate
  }
}
