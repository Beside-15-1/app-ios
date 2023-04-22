import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {

  static let bundleID = "com.cheonsong"
  static let iosVersion = "14.0"

  /// Helper function to create the Project for this ExampleApp
  public static func app(
    name: String,
    dependencies: [TargetDependency] = [],
    resources: ProjectDescription.ResourceFileElements? = nil
  ) -> Project {
    project(
      name: name,
      product: .app,
      bundleID: bundleID + "\(name.lowercased())",
      dependencies: dependencies,
      resources: resources
    )
  }
}

extension Project {
  public static func framework(
    name: String,
    dependencies: [TargetDependency] = [],
    resources: ProjectDescription.ResourceFileElements? = nil
  ) -> Project {
    .project(
      name: name,
      product: .staticFramework,
      bundleID: bundleID + ".\(name.lowercased())",
      dependencies: dependencies,
      resources: resources
    )
  }



  public static func project(
    name: String,
    product: Product,
    bundleID: String,
    schemes: [Scheme] = [],
    dependencies: [TargetDependency] = [],
    resources: ProjectDescription.ResourceFileElements? = nil
  ) -> Project {
    var target: [Target] = []
    if product == .app {
      target = [Target(
        name: name,
        platform: .iOS,
        product: product,
        bundleId: bundleID,
        deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
        infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
        sources: ["Sources/**"],
        resources: resources,
        dependencies: dependencies
      )]
    } else {
      target = [
        Target(
          name: "\(name)Interface",
          platform: .iOS,
          product: product,
          bundleId: bundleID,
          deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
          infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
          sources: ["Interfaces/**"],
          resources: resources,
          dependencies: dependencies
        )
        ,Target(
          name: name,
          platform: .iOS,
          product: product,
          bundleId: bundleID,
          deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
          infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
          sources: ["Sources/**"],
          resources: resources,
          dependencies: dependencies
        ),
        Target(
          name: "\(name)Tests",
          platform: .iOS,
          product: .unitTests,
          bundleId: bundleID,
          deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
          infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
          sources: "Tests/**",
          dependencies: [
            .target(name: "\(name)"),
            .target(name: "\(name)Interface")
          ]
        )
      ]
    }

    return Project(
      name: name,
      targets: target,
      schemes: schemes
    )
  }
}

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
  public static let kingfisher: TargetDependency = .external(name: "Kingfisher")
  public static let rxKeyboard: TargetDependency = .external(name: "RxKeyboard")
  public static let lottie: TargetDependency = .external(name: "Lottie")
  public static let rxGesture: TargetDependency = .external(name: "RxGesture")
  public static let swiftyJson: TargetDependency = .external(name: "SwiftyJSON")
}
