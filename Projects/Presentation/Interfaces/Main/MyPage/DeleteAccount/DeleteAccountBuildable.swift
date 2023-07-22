//
//  DeleteAccountBuildable.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/22.
//

import Foundation
import UIKit

import Domain

public protocol DeleteAccountBuildable {

  func build(payload: DeleteAccountPayload) -> UIViewController
}

public struct DeleteAccountPayload {

  public let delegate: DeleteAccountDelegate?

  public init(
    delegate: DeleteAccountDelegate?
  ) {
    self.delegate = delegate
  }
}
