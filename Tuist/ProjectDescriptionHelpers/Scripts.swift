//
//  Scripts.swift
//  ProjectDescriptionHelpers
//
//  Created by Hohyeon Moon on 2023/04/29.
//

import ProjectDescription

public extension TargetScript {
    static let SwiftFormatString = TargetScript.pre(script: """
export PATH="$PATH:/opt/homebrew/bin"
if which swiftformat > /dev/null; then
  swiftformat .
else
  echo "warning: SwiftFormat not installed, download from https://github.com/nicklockwood/SwiftFormat"
fi
""", name: "Swift Format")
}
