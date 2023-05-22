//
//  FadeAnimator.swift
//  Presentation
//
//  Created by 박천송 on 2023/05/22.
//

import Foundation
import UIKit

// MARK: - FadeAnimator

public class FadeAnimator: NSObject {
  // MARK: - Vars & Lets

  let animationDuration: Double
  weak var storedContext: UIViewControllerContextTransitioning?
  private var isPresenting = false

  // MARK: - Initialization

  public init(animationDuration: Double, isPresenting: Bool) {
    self.animationDuration = animationDuration
    self.isPresenting = isPresenting
  }
}

// MARK: UIViewControllerAnimatedTransitioning

extension FadeAnimator: UIViewControllerAnimatedTransitioning {
  public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return animationDuration
  }

  public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
    let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)

    if isPresenting {
      if let toView {
        toView.alpha = 0
        transitionContext.containerView.addSubview(toView)
      }
    } else {
      if let toView {
        if let fromView {
          fromView.alpha = 1
          transitionContext.containerView.insertSubview(toView, belowSubview: fromView)
        }
      }
    }

    let duration = transitionDuration(using: transitionContext)

    UIView.animate(withDuration: duration,
                   animations: {
                     if self.isPresenting {
                       toView?.alpha = 1
                     } else {
                       fromView?.alpha = 0
                     }
                   }) { _ in
      transitionContext.completeTransition(true)
    }
  }
}
