//
//  GuideUseCase.swift
//  Domain
//
//  Created by 박천송 on 2023/04/27.
//

import Foundation

// MARK: - GuideUseCase

public protocol GuideUseCase {
  func excute() -> String
}

// MARK: - GuideUseCaseImpl

public class GuideUseCaseImpl: GuideUseCase {
  private let guideRepository: GuideRepository

  public init(guideRepository: GuideRepository) {
    self.guideRepository = guideRepository
  }

  public func excute() -> String {
    return guideRepository.fetch()
  }
}
