import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: Module.App.rawValue,
  options: .options(
    textSettings: .textSettings(
      indentWidth: 2,
      tabWidth: 2,
      wrapsLines: true
    )
  ),
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
      entitlements: .relativeToRoot("Projects/Joosum/Joosum.entitlements"),
      dependencies: [
        // Module
        .data(),
        .presentation(),
        // Core
        .core(impl: .PBNetworking),
        .core(impl: .PBAnalytics),
        .core(impl: .PBLog),
        .core(impl: .PBAuth),
        .core(interface: .PBAuth),
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
