//
//  LoginBuildable.swift
//  PresentationInterface
//
//  Created by 박천송 on 2023/04/27.
//

import Foundation

import UIKit

import Domain

// MARK: - LoginBuildable

/// @mockable
public protocol LoginBuildable {
  func build(payload: LoginPayload) -> UIViewController
}

// MARK: - LoginPayload

public struct LoginPayload {
  public init() {}
}
