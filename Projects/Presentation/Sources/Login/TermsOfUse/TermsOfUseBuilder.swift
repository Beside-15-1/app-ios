import Foundation
import UIKit

import Domain
import PresentationInterface

// MARK: - TermsOfUseDependency

struct TermsOfUseDependency {}

// MARK: - TermsOfUseBuilder

final class TermsOfUseBuilder: TermsOfUseBuildable {
  private let dependency: TermsOfUseDependency

  init(dependency: TermsOfUseDependency) {
    self.dependency = dependency
  }

  func build(payload: TermsOfUsePayload) -> UIViewController {
    let viewModel = TermsOfUseViewModel()

    let viewController = TermsOfUseViewController(
      viewModel: viewModel
    )

    return viewController
  }
}
