//
//  MyPageBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/05/19.
//

import Foundation
import UIKit

import Domain
import PresentationInterface

// MARK: - MyPageDependency

struct MyPageDependency {}

// MARK: - MyPageBuilder

final class MyPageBuilder: MyPageBuildable {
  private let dependency: MyPageDependency

  init(dependency: MyPageDependency) {
    self.dependency = dependency
  }

  func build(payload: MyPagePayload) -> UIViewController {
    let viewModel = MyPageViewModel()

    let viewController = MyPageViewController(
      viewModel: viewModel
    )

    return viewController
  }
}
