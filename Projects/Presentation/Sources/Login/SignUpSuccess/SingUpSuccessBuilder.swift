//
//  SingUpSuccessBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/25.
//

import UIKit
import Foundation

import Domain
import PresentationInterface

struct SingUpSuccessDependency {}

final class SingUpSuccessBuilder: SingUpSuccessBuildable {

  private let dependency: SingUpSuccessDependency

  init(dependency: SingUpSuccessDependency) {
    self.dependency = dependency
  }

  func build(payload: SingUpSuccessPayload) -> UIViewController {
    let reactor = SingUpSuccessViewReactor()

    let viewController = SingUpSuccessViewController(
      reactor: reactor
    ).then {
      $0.delegate = payload.delegate
    }

    return viewController
  }
}
