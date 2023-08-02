import UIKit

import Domain
import Presentation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let scene = (scene as? UIWindowScene) else { return }
    let dependency = (UIApplication.shared.delegate as! AppDelegate).dependency

    let window = UIWindow(windowScene: scene)
    window.rootViewController = dependency.rootViewController
    self.window = window
    window.makeKeyAndVisible()
  }
}
