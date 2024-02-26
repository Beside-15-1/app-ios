//
//  CustomFilterDelegate.swift
//  PresentationInterface
//
//  Created by 박천송 on 1/11/24.
//

import Foundation

import Domain

public protocol CustomFilterDelegate: AnyObject {
  func customFilterConfirmButtonTapped(
    customFilter: CustomFilter?
  )

  func customFilterResetButtonTapped()
}
