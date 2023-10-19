import Foundation
import UIKit

import Domain
import PBAnalyticsInterface
import PresentationInterface

// MARK: - TermsOfUseDependency

struct TermsOfUseDependency {
  let analytics: PBAnalytics
  let webBuilder: PBWebBuildable
}

// MARK: - TermsOfUseBuilder

final class TermsOfUseBuilder: TermsOfUseBuildable {
  private let dependency: TermsOfUseDependency

  init(dependency: TermsOfUseDependency) {
    self.dependency = dependency
  }

  func build(payload: TermsOfUsePayload) -> UIViewController {
    let viewModel = TermsOfUseViewModel(
      analytics: dependency.analytics
    )

    let viewController = TermsOfUseViewController(
      viewModel: viewModel,
      analytics: dependency.analytics,
      webBuilder: dependency.webBuilder
    ).then {
      $0.delegate = payload.delegate
    }

    return viewController
  }
}
