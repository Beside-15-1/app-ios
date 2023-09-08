//
//  PopOverPresenter.swift
//  DesignSystem
//
//  Created by 박천송 on 2023/08/31.
//

import Foundation
import UIKit

import PanModal

extension UIViewController {

  public func presentPaperSheet(_ viewController: UIViewController) {
    if UIDevice.current.userInterfaceIdiom == .pad {
      viewController.modalPresentationStyle = .pageSheet
    } else {
      viewController.modalPresentationStyle = .popover
    }

    present(viewController, animated: true, completion: nil)
  }
}

extension UIViewController {

  public func presentModal(
    _ viewController: UIViewController & PanModalPresentable.LayoutType,
    preferredContentSize: CGSize = .zero,
    arrowDirection: UIPopoverArrowDirection = .any,
    sourceView: UIView? = nil,
    sourceRect: CGRect = .zero
  ) {
    if UIDevice.current.userInterfaceIdiom == .pad {
      viewController.preferredContentSize = preferredContentSize
      viewController.popoverPresentationController?.permittedArrowDirections = arrowDirection
      viewController.modalPresentationStyle = .popover
      viewController.popoverPresentationController?.sourceRect = sourceRect
      viewController.popoverPresentationController?.sourceView = sourceView ?? view
      self.present(viewController, animated: true)
    } else {
      presentPanModal(viewController)
    }
  }

  public func presentPanModalInIpad(
    _ viewControllerToPresent: PanModalPresentable.LayoutType
  ) {
    viewControllerToPresent.modalPresentationStyle = .custom
    viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = true
    viewControllerToPresent.transitioningDelegate = PanModalPresentationDelegate.default

    present(viewControllerToPresent, animated: true)
  }
}
