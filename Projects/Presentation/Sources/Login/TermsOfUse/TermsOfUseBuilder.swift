import Foundation
import UIKit

import Domain
import PresentationInterface

// MARK: - TermsOfUseDependency

struct TermsOfUseDependency {
  let webBuilder: PBWebBuildable
}

// MARK: - TermsOfUseBuilder

final class TermsOfUseBuilder: TermsOfUseBuildable {
  private let dependency: TermsOfUseDependency

  init(dependency: TermsOfUseDependency) {
    self.dependency = dependency
  }

  func build(payload: TermsOfUsePayload) -> UIViewController {
    let viewModel = TermsOfUseViewModel()

    let viewController = TermsOfUseViewController(
      viewModel: viewModel,
      webBuilder: dependency.webBuilder
    ).then {
      $0.delegate = payload.delegate
    }

    return viewController
  }
}
