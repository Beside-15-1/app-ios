//
//  PBWebBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/07/22.
//

import UIKit
import Foundation

import Domain
import PresentationInterface

struct PBWebDependency {}

final class PBWebBuilder: PBWebBuildable {

  private let dependency: PBWebDependency

  init(dependency: PBWebDependency) {
    self.dependency = dependency
  }

  func build(payload: PBWebPayload) -> UIViewController {
    PBWebViewController(url: payload.url)
  }
}
