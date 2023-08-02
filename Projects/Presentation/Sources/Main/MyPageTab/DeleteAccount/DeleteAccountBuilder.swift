//
//  DeleteAccountBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/22.
//

import UIKit
import Foundation

import Domain
import PresentationInterface

struct DeleteAccountDependency {
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
      reactor: reactor
    ).then {
      $0.delegate = payload.delegate
    }

    return viewController
  }
}
