//
//  MainTabBarViewController.swift
//  Presentation
//
//  Created by 박천송 on 2023/05/19.
//

import UIKit

import RxSwift

final class MainTabBarViewController: UITabBarController {
  // MARK: Initializing

  init() {
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
  }
}
