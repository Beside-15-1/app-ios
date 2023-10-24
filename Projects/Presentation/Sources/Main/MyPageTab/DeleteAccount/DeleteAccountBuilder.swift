//
//  DeleteAccountBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/22.
//

import Foundation
import UIKit

import Domain
import PBAnalyticsInterface
import PresentationInterface

struct DeleteAccountDependency {
  let analytics: PBAnalytics
  let loginRepository: LoginRepository
}

final class DeleteAccountBuilder: DeleteAccountBuildable {

  private let dependency: DeleteAccountDependency

  init(dependency: DeleteAccountDependency) {
    self.dependency = dependency
  }

  func build(payload: DeleteAccountPayload) -> UIViewController {
    let reactor = DeleteAccountViewReactor(
      deleteAccountUseCase: DeleteAccountUseCaseImpl(
        loginRepository: dependency.loginRepository
      )
    )

    let viewController = DeleteAccountViewController(
      reactor: reactor,
      analytics: dependency.analytics
    ).then {
      $0.delegate = payload.delegate
    }

    return viewController
  }
}
