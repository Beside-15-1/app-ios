import Foundation
import UIKit

import Domain
import PBAnalyticsInterface
import PBUserDefaults
import PresentationInterface

// MARK: - TagAddDependency

struct TagAddDependency {
  let analytics: PBAnalytics
  let tagRepository: TagRepository
}

// MARK: - TagAddBuilder

final class TagAddBuilder: TagAddBuildable {
  private let dependency: TagAddDependency

  init(dependency: TagAddDependency) {
    self.dependency = dependency
  }

  func build(payload: TagAddPayload) -> UIViewController {
    let reactor = TagAddViewReactor(
      analytics: dependency.analytics,
      tagRepository: dependency.tagRepository,
      addedTagList: payload.addedTagList
    )

    let viewController = TagAddViewController(
      reactor: reactor,
      analytics: dependency.analytics
    ).then {
      $0.delegate = payload.tagAddDelegate
    }

    return viewController
  }
}
