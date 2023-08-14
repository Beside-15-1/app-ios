//
//  OnboardingBuildable.swift
//  Presentation
//
//  Created by 박천송 on 2023/08/07.
//

import Foundation
import UIKit

import Domain

public protocol OnboardingBuildable {

  func build(payload: OnboardingPayload) -> UIViewController
}

public struct OnboardingPayload {
  public init() {}
}
