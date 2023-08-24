import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: Module.Domain.rawValue,
  options: .options(
    textSettings: .textSettings(
      indentWidth: 2,
      tabWidth: 2,
      wrapsLines: true
    )
  ),
  targets: [
    Target(
      name: Module.Domain.rawValue,
      platform: .iOS,
      product: .staticFramework,
      bundleId: Project.bundleID + ".domain",
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .default,
      sources: ["Domain/**"],
      scripts: [
        TargetScript.pre(
          script: #"""
          export PATH="$PATH:/opt/homebrew/bin"

          if which mockolo; then
            mockolo -s Domain -d Testing/DomainMocks.swift -i Domain --enable-args-history --mock-final
          else
            echo "warning: mockolo not installed, download from https://github.com/uber/mockolo using Homebrew"
          fi
          """#,
          name: "Mockolo",
          outputPaths: ["Testing/DomainMocks.swift"],
          basedOnDependencyAnalysis: false
        )
      ],
      dependencies: [
        .external(dependency: .RxSwift),
        .external(dependency: .RxCocoa),
        .external(dependency: .RxRelay)
      ]
    ),
    Target(
      name: "Data",
      platform: .iOS,
      product: .staticFramework,
      bundleId: Project.bundleID + ".data",
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .default,
      sources: ["Data/**"],
      dependencies: [
        .target(name: "Domain"),
        .core(impl: .PBNetworking),
        .core(interface: .PBAuth),
        .external(dependency: .RxSwift),
        .external(dependency: .RxCocoa),
        .external(dependency: .RxRelay),
        .external(dependency: .Swinject),
        .external(dependency: .Moya),
        .external(dependency: .SwiftSoup)
      ]
    ),
    Target(
      name: "\(Module.Domain.rawValue)Testing",
      platform: .iOS,
      product: .staticFramework,
      bundleId: Project.bundleID + ".domaintesting",
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .default,
      sources: ["Testing/**"],
      dependencies: [
        .target(name: "Domain")
      ]
    ),
    Target(
      name: "\(Module.Domain.rawValue)Tests",
      platform: .iOS,
      product: .unitTests,
      bundleId: Project.bundleID + ".domaintests",
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .default,
      sources: ["Tests/**"],
      dependencies: [
        .target(name: "Domain"),
        .target(name: "Data"),
        .target(name: "DomainTesting"),
        .core(impl: .PBNetworking),
        .core(testing: .PBAuth),
        .external(dependency: .RxSwift),
        .external(dependency: .RxCocoa),
        .external(dependency: .RxRelay),
        .external(dependency: .Nimble)
      ]
    )
  ]
)
