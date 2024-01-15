//
//  PeriodType.swift
//  Domain
//
//  Created by 박천송 on 1/11/24.
//

import Foundation

public enum PeriodType: String, Hashable, CaseIterable {
  /// 전체
  case all = "전체"
  /// 최근 1주
  case week = "최근 1주"
  /// 최근 1개월
  case month = "최근 1개월"
  /// 기간설정
  case custom = "기간설정"
}
