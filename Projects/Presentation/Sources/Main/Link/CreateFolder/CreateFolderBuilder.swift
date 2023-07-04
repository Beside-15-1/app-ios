import Foundation
import UIKit

import Domain
import PresentationInterface

// MARK: - CreateFolderDependency

struct CreateFolderDependency {}

// MARK: - CreateFolderBuilder

final class CreateFolderBuilder: CreateFolderBuildable {
  private let dependency: CreateFolderDependency

  init(dependency: CreateFolderDependency) {
    self.dependency = dependency
  }

  func build(payload: CreateFolderPayload) -> UIViewController {
    let reactor = CreateFolderViewReactor()

    let viewController = CreateFolderViewController(
      reactor: reactor
    )

    return viewController
  }
}
