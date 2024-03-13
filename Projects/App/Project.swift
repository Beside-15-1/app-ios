import ProjectDescription
import ProjectDescriptionHelpers


// MARK: - Target

let joosumTarget = Target.target(
  name: "Joosum",
  product: .app,
  bundleId: Project.bundleID + ".joosumapp".lowercased(),
  infoPlist: .file(path: "Joosum/Supporting Files/Info.plist"),
  sources: ["Joosum/Sources/**"],
  resources: [
    "Joosum/Resources/**",
    .glob(pattern: .relativeToRoot("Projects/App/Joosum/Supporting Files/GoogleService-Info.plist")),
  ],
  entitlements: .file(path: .relativeToRoot("Projects/App/Joosum/Supporting Files/Joosum.entitlements")),
  dependencies: [
    .target(name: "ShareExtension", condition: nil),
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
    .external(dependency: .FirebaseMessaging),
  ],
  settings: .settings(
    base: [
      "OTHER_LDFLAGS": "$(inherited) -ObjC",
      "CODE_SIGN_STYLE": "7ZK7Q3JHK4",
      "DEVELOPMENT_TEAM": "7ZK7Q3JHK4"
    ],
    configurations: []
  )
)

let shareExtensionTarget = Target.target(
  name: "ShareExtension",
  product: .appExtension,
  bundleId: Project.bundleID + ".joosumapp".lowercased() + ".share",
  infoPlist: .file(path: "ShareExtension/Supporting Files/Info.plist"),
  sources: ["ShareExtension/Sources/**"],
  resources: [
    "ShareExtension/Resources/**",
    .glob(pattern: .relativeToRoot("Projects/App/Joosum/Supporting Files/GoogleService-Info.plist")),
  ],
  entitlements: .file(path: .relativeToRoot("Projects/App/ShareExtension/Supporting Files/ShareExtension.entitlements")),
  dependencies: [
    // Module
    .data(),
    .designSystem(),
    .domain(),
    // Core
    .core(impl: .PBNetworking),
    .core(impl: .PBLog),
    .core(impl: .PBAuth),
    .core(impl: .PBUserDefaults),
    .core(interface: .PBAuth),
    .core(interface: .PBAnalytics),
    // External
    .external(dependency: .Swinject),
    .external(dependency: .ReactorKit),
    .external(dependency: .RxSwift),
    .external(dependency: .RxCocoa),
    .external(dependency: .RxRelay),
    .external(dependency: .RxKeyboard),
    .external(dependency: .KeychainAccess),
    .external(dependency: .SwiftSoup),
    .external(dependency: .FirebaseAnalytics),
  ],
  settings: .settings(
    base: [
      "OTHER_LDFLAGS": "$(inherited) -ObjC",
      "CODE_SIGN_STYLE": "7ZK7Q3JHK4",
      "DEVELOPMENT_TEAM": "7ZK7Q3JHK4"
    ],
    configurations: []
  )
)


// MARK: - Project

let project = Project.project(
  name: "Joosum",
  targets: [
    joosumTarget,
    shareExtensionTarget,
  ],
  additionalFiles: [
    .glob(pattern: .relativeToRoot("Projects/App/Joosum/Supporting Files/GoogleService-Info.plist")),
  ]
)
