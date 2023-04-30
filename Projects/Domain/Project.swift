import ProjectDescription
import ProjectDescriptionHelpers

// let project = Project.framework(
//  name: Module.domain.name,
//  dependencies: [.rxSwift, .rxCocoa, .rxRelay]
// )

let bundleID = "com.cheonsong"
let iosVersion = "14.0"

let protject = Project(
  name: Module.domain.name,
  targets: [
    Target(
      name: "Domain",
      platform: .iOS,
      product: .staticFramework,
      bundleId: bundleID + ".domain",
      deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Domain/**"],
      scripts: [.SwiftFormatString],
      dependencies: [
        .rxSwift,
        .rxCocoa,
        .rxRelay,
      ]
    ),
    Target(
      name: "Data",
      platform: .iOS,
      product: .staticFramework,
      bundleId: bundleID + ".data",
      deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Data/**"],
      scripts: [.SwiftFormatString],
      dependencies: [
        Module.core.project,
        .rxSwift,
        .rxCocoa,
        .rxRelay,
      ]
    ),
    Target(
      name: "DomainTests",
      platform: .iOS,
      product: .unitTests,
      bundleId: bundleID + ".domain",
      deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Tests/**"],
      scripts: [.SwiftFormatString],
      dependencies: [
        .rxSwift,
        .rxCocoa,
        .rxRelay,
      ]
    ),
  ]
)

// Project {
//  var target: [Target] = []
//  if product == .app {
//    target = [Target(
//      name: name,
//      platform: .iOS,
//      product: product,
//      bundleId: bundleID,
//      deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
//      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
//      sources: ["Sources/**"],
//      resources: resources,
//      dependencies: dependencies
//    )]
//  } else {
//    target = [
//      Target(
//        name: "\(name)Interface",
//        platform: .iOS,
//        product: product,
//        bundleId: bundleID,
//        deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
//        infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
//        sources: ["Interfaces/**"],
//        resources: resources,
//        dependencies: dependencies
//      )
//      ,Target(
//        name: name,
//        platform: .iOS,
//        product: product,
//        bundleId: bundleID,
//        deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
//        infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
//        sources: ["Sources/**"],
//        resources: resources,
//        dependencies: dependencies
//      ),
//      Target(
//        name: "\(name)Tests",
//        platform: .iOS,
//        product: .unitTests,
//        bundleId: bundleID,
//        deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
//        infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
//        sources: "Tests/**",
//        dependencies: [
//          .target(name: "\(name)"),
//          .target(name: "\(name)Interface")
//        ]
//      )
//    ]
//  }
//
//  return Project(
//    name: name,
//    targets: target,
//    schemes: schemes
//  )
