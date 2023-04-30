//
//  TargetDependency+.swift
//  ProjectDescriptionHelpers
//
//  Created by 박천송 on 2023/04/25.
//

import Foundation

import ProjectDescription

extension TargetDependency {
  public static let rxSwift: TargetDependency = .external(name: "RxSwift")
  public static let rxCocoa: TargetDependency = .external(name: "RxCocoa")
  public static let rxRelay: TargetDependency = .external(name: "RxRelay")
  public static let rxDataSources: TargetDependency = .external(name: "RxDataSources")
  public static let alamofire: TargetDependency = .external(name: "Alamofire")
  public static let moya: TargetDependency = .external(name: "Moya")
  public static let rxMoya: TargetDependency = .external(name: "RxMoya")
  public static let snapKit: TargetDependency = .external(name: "SnapKit")
  public static let then: TargetDependency = .external(name: "Then")
  public static let rxKeyboard: TargetDependency = .external(name: "RxKeyboard")
  public static let lottie: TargetDependency = .external(name: "Lottie")
  public static let rxGesture: TargetDependency = .external(name: "RxGesture")
  public static let swiftyJson: TargetDependency = .external(name: "SwiftyJSON")
  public static let reactorKit: TargetDependency = .external(name: "ReactorKit")
  public static let swinject: TargetDependency = .external(name: "Swinject")
  public static let sdWebImage: TargetDependency = .external(name: "SDWebImage")
}
