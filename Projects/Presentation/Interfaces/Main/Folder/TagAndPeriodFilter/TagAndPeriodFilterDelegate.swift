//
//  TagAndPeriodFilterDelegate.swift
//  PresentationInterface
//
//  Created by 박천송 on 1/11/24.
//

import Foundation

import Domain

public protocol TagAndPeriodFilterDelegate: AnyObject {
  func tagAndPeriodFilterConfirmButtonTapped(
    customFilter: CustomFilter?
  )

  func tagAndPeriodFilterResetButtonTapped()
}
