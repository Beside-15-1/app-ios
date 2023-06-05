import Domain
import Presentation
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var dependency: AppDependency?
  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    guard let scene = (scene as? UIWindowScene) else { return }
    dependency = (UIApplication.shared.delegate as? AppDelegate)?.dependency

    let window = UIWindow(windowScene: scene)
    window.rootViewController = dependency?.rootViewController
    self.window = window
    window.makeKeyAndVisible()
  }
}
