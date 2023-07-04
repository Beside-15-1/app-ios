//___FILEHEADER___

import UIKit
import Foundation

import Domain
import PresentationInterface

struct ___VARIABLE_sceneName___Dependency {}

final class ___VARIABLE_sceneName___Builder: ___VARIABLE_sceneName___Buildable {

  private let dependency: ___VARIABLE_sceneName___Dependency

  init(dependency: ___VARIABLE_sceneName___Dependency) {
    self.dependency = dependency
  }

  func build(payload: ___VARIABLE_sceneName___Payload) -> UIViewController {
    let reactor = ___VARIABLE_sceneName___ViewReactor()

    let viewController = ___VARIABLE_sceneName___ViewController(
      reactor: reactor
    )

    return viewController
  }
}
