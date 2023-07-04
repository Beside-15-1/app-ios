import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: Module.Presentation.rawValue,
  options: .options(
    textSettings: .textSettings(
      indentWidth: 2,
      tabWidth: 2,
      wrapsLines: true
    )
  ),
  targets: [
    Target(
      name: "\(Module.Presentation.rawValue)Interface",
      platform: .iOS,
      product: .staticFramework,
      bundleId: Project.bundleID + ".\(Module.Presentation.rawValue)Interface",
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Interfaces/**"],
      scripts: [
        TargetScript.pre(
          script: #"""
          export PATH="$PATH:/opt/homebrew/bin"

          if which mockolo; then
            mockolo -s Interfaces -d Testing/PresentationMocks.swift -i PresentationInterface --enable-args-history --mock-final
          else
            echo "warning: mockolo not installed, download from https://github.com/uber/mockolo using Homebrew"
          fi
          """#,
          name: "Mockolo",
          outputPaths: ["Testing/PresentationMocks.swift"],
          basedOnDependencyAnalysis: false
        )
      ],
      dependencies: [
        .domain()
      ]
    ),
    Target(
      name: Module.Presentation.rawValue,
      platform: .iOS,
      product: .staticFramework,
      bundleId: Project.bundleID + ".\(Module.Presentation.rawValue)",
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Sources/**"],
      dependencies: [
        // Target
        .target(name: "\(Module.Presentation.rawValue)Interface"),
        // Module
        .domain(),
        .designSystem(),
        .core(interface: .PBAnalytics),
        .core(impl: .PBUserDefaults),
        // External
        .external(dependency: .ReactorKit),
        .external(dependency: .Swinject),
        .external(dependency: .SDWebImage),
        .external(dependency: .PanModal),
        .external(dependency: .Toaster)
      ]
    ),
    Target(
      name: "\(Module.Presentation.rawValue)Testing",
      platform: .iOS,
      product: .staticFramework,
      bundleId: Project.bundleID + ".\(Module.Presentation.rawValue)Testing",
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: "Testing/**",
      dependencies: [
        .target(name: "\(Module.Presentation.rawValue)Interface")
      ]
    ),
    Target(
      name: "\(Module.Presentation.rawValue)Tests",
      platform: .iOS,
      product: .unitTests,
      bundleId: Project.bundleID + ".\(Module.Presentation.rawValue)Tests",
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: "Tests/**",
      dependencies: [
        .xctest,
        .target(name: "\(Module.Presentation.rawValue)"),
        .target(name: "\(Module.Presentation.rawValue)Testing"),
        // Module
        .domain(),
        .domainTesting(),
        .core(testing: .PBAnalytics),
        .external(dependency: .Nimble)
      ]
    )
  ]
)
