//
//  NavigationController.swift
//  DesignSystem
//
//  Created by 박천송 on 2023/08/28.
//

import UIKit

open class NavigationController: UINavigationController {

  // MARK: Properties

  open override var preferredStatusBarStyle: UIStatusBarStyle {
    self.topViewController?.preferredStatusBarStyle ?? .default
  }

  public var isPopGestureEnabled = true // default is true


  // MARK: Initializing

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    self.modalPresentationStyle = .fullScreen
  }

  public override init(rootViewController: UIViewController) {
    super.init(rootViewController: rootViewController)
    self.modalPresentationStyle = .fullScreen
  }

  public convenience init() {
    self.init(nibName: nil, bundle: nil)
  }

  required public init?(coder: NSCoder) {
    super.init(coder: coder)
    self.modalPresentationStyle = .fullScreen
  }


  // MARK: View Life Cycle

  open override func viewDidLoad() {
    super.viewDidLoad()

    interactivePopGestureRecognizer?.delegate = self
  }
}


extension NavigationController: UIGestureRecognizerDelegate {

  public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    guard isPopGestureEnabled == true else { return false }
    return viewControllers.count > 1
  }

  public func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer
  ) -> Bool {
    if gestureRecognizer === interactivePopGestureRecognizer { return true }
    return false
  }
}
