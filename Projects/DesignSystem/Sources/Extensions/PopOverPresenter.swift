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

  public func presentFormSheet(_ viewController: UIViewController) {
    if UIDevice.current.userInterfaceIdiom == .pad {
      viewController.modalPresentationStyle = .formSheet
    } else {
      viewController.modalPresentationStyle = .popover
    }

    present(viewController, animated: true, completion: nil)
  }
}

extension UIViewController {

  public func presentModal(_ viewController: UIViewController & PanModalPresentable.LayoutType) {
    if UIDevice.current.userInterfaceIdiom == .pad {
      presentPanModalInIpad(viewController)
    } else {
      presentPanModal(viewController)
    }
  }

  private func presentPanModalInIpad(
    _ viewControllerToPresent: PanModalPresentable.LayoutType,
    sourceView: UIView? = nil,
    sourceRect: CGRect = .zero
  ) {
    viewControllerToPresent.modalPresentationStyle = .custom
    viewControllerToPresent.modalPresentationCapturesStatusBarAppearance = true
    viewControllerToPresent.transitioningDelegate = PanModalPresentationDelegate.default

    present(viewControllerToPresent, animated: true)
  }
}
