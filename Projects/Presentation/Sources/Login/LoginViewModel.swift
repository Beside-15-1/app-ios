//
//  LoginViewModel.swift
//  PresentationInterface
//
//  Created by 박천송 on 2023/04/27.
//

import Foundation

import Domain

final class LoginViewModel {
  private let guideUseCase: GuideUseCase

  init(guideUseCase: GuideUseCase) {
    self.guideUseCase = guideUseCase
  }
}
