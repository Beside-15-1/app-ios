//
//  MainTabBarController.swift
//  Presentation
//
//  Created by 박천송 on 2023/04/25.
//

import Foundation

import UIKit

public class MainTabBarController: UITabBarController {

  let mvvm = MVVMViewController()
  let reactorKit = ReactorViewController()

  public override func viewDidLoad() {
    super.viewDidLoad()

    tabBar.isHidden = false

    mvvm.tabBarItem.title = "MVVM"
    reactorKit.tabBarItem.title = "ReactorKit"

    viewControllers = [mvvm, reactorKit]
  }
}
