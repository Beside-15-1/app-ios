import ProjectDescription

/// Project helpers are functions that simplify the way you define your project.
/// Share code to create targets, settings, dependencies,
/// Create your own conventions, e.g: a func that makes sure all shared targets are "static frameworks"
/// See https://docs.tuist.io/guides/helpers/

extension Project {
  public static let bundleID = "com.pinkboss"
  public static let iosVersion = "14.0"

  /// Helper function to create the Project for this ExampleApp
  public static func app(
    name: String,
    dependencies: [TargetDependency] = [],
    resources: ProjectDescription.ResourceFileElements? = nil
  ) -> Project {
    project(
      name: name,
      product: .app,
      bundleID: bundleID + ".\(name.lowercased())",
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
    var targets: [Target] = []

    targets = [Target(
      name: name,
      platform: .iOS,
      product: product,
      bundleId: bundleID,
      deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Sources/**"],
      resources: resources,
      entitlements: .relativeToRoot("Projects/Joosum/Joosum.entitlements"),
      scripts: [.SwiftFormatString],
      dependencies: dependencies
    )]

    return Project(
      name: name,
      targets: targets,
      schemes: schemes
    )
  }
}
