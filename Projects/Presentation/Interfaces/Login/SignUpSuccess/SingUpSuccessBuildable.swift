//
//  SingUpSuccessBuildable.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/25.
//

import Foundation
import UIKit

import Domain

public protocol SingUpSuccessBuildable {

  func build(payload: SingUpSuccessPayload) -> UIViewController
}

public struct SingUpSuccessPayload {

  public let delegate: SignUpSuccessDelegate?

  public init(
    delegate: SignUpSuccessDelegate?
  ) {
    self.delegate = delegate
  }
}
