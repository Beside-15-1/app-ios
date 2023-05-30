//
//  PBAuthLocalDataSourceImplTest.swift
//  PBAuthTests
//
//  Created by 박천송 on 2023/05/30.
//

import Foundation
import XCTest

import Nimble

@testable import PBAuth
import PBAuthTesting

// MARK: - PBAuthLocalDataSourceImplTest

final class PBAuthLocalDataSourceImplTest: XCTestCase {
  var sut: PBAuthLocalDataSourceImpl?

  override func setUp() {
    super.setUp()
    sut = .init(keychain: KeychainProtocolFake())
  }

  override func tearDown() {
    super.tearDown()
    sut = nil
  }
}

extension PBAuthLocalDataSourceImplTest {
  func test_accessToken_을_저장해요() {
    // when
    sut?.accessToken = "ab23b2fbkjfbab23"

    // then
    expect(self.sut?.accessToken) == "ab23b2fbkjfbab23"
  }

  func test_refreshToken_을_저장해요() {
    // when
    sut?.refreshToken = "agewbasdbdsav"

    // then
    expect(self.sut?.refreshToken) == "agewbasdbdsav"
  }
}
