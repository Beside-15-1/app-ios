import Foundation
import UIKit

import Domain
import PBAnalyticsInterface
import PBUserDefaults
import PresentationInterface

// MARK: - TagAddDependency

struct TagAddDependency {
  let analytics: PBAnalytics
}

// MARK: - TagAddBuilder

final class TagAddBuilder: TagAddBuildable {
  private let dependency: TagAddDependency

  init(dependency: TagAddDependency) {
    self.dependency = dependency
  }

  func build(payload: TagAddPayload) -> UIViewController {
    let viewModel = TagAddViewModel(
      userDefaults: UserDefaultsManager.shared,
      addedTagList: payload.addedTagList
    )

    let viewController = TagAddViewController(
      viewModel: viewModel,
      analytics: dependency.analytics
    ).then {
      $0.delegate = payload.tagAddDelegate
    }

    return viewController
  }
}
