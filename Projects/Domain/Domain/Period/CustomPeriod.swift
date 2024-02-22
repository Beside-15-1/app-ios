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
    self.startDate = Date(timeIntervalSinceNow: -3600 * 24 * 30)
    self.endDate = Date()
  }

  public init(startDate: Date, endDate: Date) {
    self.startDate = startDate
    self.endDate = endDate
  }
}
