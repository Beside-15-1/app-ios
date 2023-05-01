//
//  GuideRepository.swift
//  Domain
//
//  Created by 박천송 on 2023/04/27.
//

import Foundation

public protocol GuideRepository {
  func fetch() -> String
}
