//
//  EntryBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/05/19.
//

import Foundation
import UIKit

import Domain
import PresentationInterface

// MARK: - EntryDependency

struct EntryDependency {}

// MARK: - EntryBuilder

final class EntryBuilder: EntryBuildable {
  private let dependency: EntryDependency

  init(dependency: EntryDependency) {
    self.dependency = dependency
  }

  func build(payload: EntryPayload) -> UIViewController {
    let viewModel = EntryViewModel()

    let viewController = EntryViewController(
      viewModel: viewModel
    )

    return viewController
  }
}
