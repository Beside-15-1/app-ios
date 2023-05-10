import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: Module.App.rawValue,
  targets: [
    Target(
      name: Module.App.rawValue,
      platform: .iOS,
      product: .app,
      bundleId: Project.bundleID + ".\(Module.App.rawValue)".lowercased(),
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Sources/**"],
      resources: [
        "Resources/**",
        .glob(pattern: .relativeToRoot("Supporting Files/GoogleService-Info.plist"))
      ],
      scripts: [.SwiftFormatString],
      dependencies: [
        // Module
        .data(),
        .presentation(),
        // Core
        .core(impl: .Networking),
        // External
        .external(dependency: .Swinject),
        .external(dependency: .FirebaseAnalytics)
      ],
      settings: .settings(
        base: ["OTHER_LDFLAGS": "$(inherited) -ObjC"],
        configurations: []
      )
    )
  ],
  additionalFiles: [
    .glob(pattern: .relativeToRoot("Supporting Files/GoogleService-Info.plist"))
  ]
)
