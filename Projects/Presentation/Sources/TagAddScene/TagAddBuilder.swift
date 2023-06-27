import Foundation
import UIKit

import Domain
import PresentationInterface

// MARK: - TagAddDependency

struct TagAddDependency {}

// MARK: - TagAddBuilder

final class TagAddBuilder: TagAddBuildable {
  private let dependency: TagAddDependency

  init(dependency: TagAddDependency) {
    self.dependency = dependency
  }

  func build(payload: TagAddPayload) -> UIViewController {
    let viewModel = TagAddViewModel(
      addedTagList: payload.addedTagList
    )

    let viewController = TagAddViewController(
      viewModel: viewModel
    ).then {
      $0.delegate = payload.tagAddDelegate
    }

    return viewController
  }
}
