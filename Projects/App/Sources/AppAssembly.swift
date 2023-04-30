//
//  AppAssembly.swift
//  App
//
//  Created by 박천송 on 2023/04/27.
//

import Foundation
import UIKit

import Swinject

import Data
import PresentationInterface
import Presentation

struct AppDependency {
  let rootViewController: UIViewController
}

enum AppAssembly {
  static let container: Container = .init(defaultObjectScope: .container)

  static func resolve()-> AppDependency {
    let assemblies: [Assembly] = [
      DataAssembly(),
      PresentationAssembly()
    ]

    _ = Assembler(assemblies, container: container)
    let resolver = container


    let rootViewController = resolver.resolve(LoginBuildable.self)!.build(payload: .init())

    return AppDependency(
      rootViewController: rootViewController
    )
  }
}
