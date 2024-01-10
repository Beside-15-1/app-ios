//
//  LinkPeriodType.swift
//  Presentation
//
//  Created by 박천송 on 12/20/23.
//

import Foundation

enum LinkPeriodType: String, Hashable, CaseIterable {
  /// 전체
  case all = "전체"
  /// 최근 1주
  case week = "최근 1주"
  /// 최근 1개월
  case month = "최근 1개월"
  /// 기간설정
  case custom = "기간설정"
}
