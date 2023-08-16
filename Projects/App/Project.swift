import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: "Joosum",
  options: .options(
    textSettings: .textSettings(
      indentWidth: 2,
      tabWidth: 2,
      wrapsLines: true
    )
  ),
  targets: [
    Target(
      name: "Joosum",
      platform: .iOS,
      product: .app,
      bundleId: Project.bundleID + ".joosumapp".lowercased(),
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone]),
      infoPlist: .file(path: "Joosum/Supporting Files/Info.plist"),
      sources: ["Joosum/Sources/**"],
      resources: [
        "Joosum/Resources/**",
        .glob(pattern: .relativeToRoot("Projects/App/Joosum/Supporting Files/GoogleService-Info.plist")),
      ],
      entitlements: .relativeToRoot("Projects/App/Joosum/Supporting Files/Joosum.entitlements"),
      dependencies: [
        .target(name: "ShareExtension"),
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
        .external(dependency: .FirebaseAnalytics),
      ],
      settings: .settings(
        base: ["OTHER_LDFLAGS": "$(inherited) -ObjC"],
        configurations: []
      )
    ),
    Target(
      name: "ShareExtension",
      platform: .iOS,
      product: .appExtension,
      bundleId: Project.bundleID + ".joosumapp".lowercased() + ".share",
      infoPlist: .file(path: "ShareExtension/Supporting Files/Info.plist"),
      sources: ["ShareExtension/Sources/**"],
      resources: ["ShareExtension/Resources/**"],
      dependencies: [
        // Module
        .data(),
        .designSystem(),
        // Core
        .core(impl: .PBNetworking),
        .core(impl: .PBLog),
        .core(impl: .PBAuth),
        .core(interface: .PBAuth),
        // External
        .external(dependency: .Swinject),
      ],
      settings: .settings(
        base: ["OTHER_LDFLAGS": "$(inherited) -ObjC"],
        configurations: []
      )
    ),
  ],
  additionalFiles: [
    .glob(pattern: .relativeToRoot("Projects/App/Joosum/Supporting Files/GoogleService-Info.plist")),
  ]
)
