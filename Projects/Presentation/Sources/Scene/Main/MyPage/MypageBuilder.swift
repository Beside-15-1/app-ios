//
//  MypageBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/05/19.
//

import Foundation
import UIKit

import Domain
import PresentationInterface

// MARK: - MypageDependency

struct MypageDependency {}

// MARK: - MypageBuilder

final class MypageBuilder: MypageBuildable {
  private let dependency: MypageDependency

  init(dependency: MypageDependency) {
    self.dependency = dependency
  }

  func build(payload: MypagePayload) -> UIViewController {
    let viewModel = MypageViewModel()

    let viewController = MypageViewController(
      viewModel: viewModel
    )

    return viewController
  }
}
