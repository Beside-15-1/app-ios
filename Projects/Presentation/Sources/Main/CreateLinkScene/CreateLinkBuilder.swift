import Foundation
import UIKit

import Domain
import PresentationInterface

// MARK: - CreateLinkDependency

struct CreateLinkDependency {}

// MARK: - CreateLinkBuilder

final class CreateLinkBuilder: CreateLinkBuildable {
  private let dependency: CreateLinkDependency

  init(dependency: CreateLinkDependency) {
    self.dependency = dependency
  }

  func build(payload: CreateLinkPayload) -> UIViewController {
    let viewModel = CreateLinkViewReactor(
      fetchThumbnailUseCase: FetchThumbnailUseCaseImpl(metadataProvider: .init())
    )

    let viewController = CreateLinkViewController(
      viewModel: viewModel
    )

    return viewController
  }
}
