import XCTest

import Nimble

@testable import PBAnalytics
import PBAnalyticsInterface
import PBAnalyticsTesting

// MARK: - FirebaseAnalyticsProtocolMock

public final class FirebaseAnalyticsProtocolMock: FirebaseAnalyticsProtocol {
  public init() {}

  public private(set) static var logEventCallCount = 0
  public static var logEventArgValues = [(String, [String: Any]?)]()
  public static var logEventHandler: ((String, [String: Any]?) -> Void)?
  public static func logEvent(_ name: String, parameters: [String: Any]?) {
    logEventCallCount += 1
    logEventArgValues.append((name, parameters))
    if let logEventHandler {
      logEventHandler(name, parameters)
    }
  }

  public static func clear() {
    logEventArgValues = []
    logEventCallCount = 0
  }
}

// MARK: - PBAnalyticsImplTest

final class PBAnalyticsImplTest: XCTestCase {
  var analytics: PBAnalyticsImpl!
  var firebase: FirebaseAnalyticsProtocolMock.Type!

  override func setUp() {
    super.setUp()
    firebase = FirebaseAnalyticsProtocolMock.self
    analytics = .init(firebaseAnalytics: FirebaseAnalyticsProtocolMock.self)
  }

  override func tearDown() {
    super.tearDown()
    firebase.clear()
  }
}

extension PBAnalyticsImplTest {
  func test_eventName만_존재하는_경우() {
    // given
    struct Dummy: PBAnalyticsType {
      let name = "sonny"
      let parameters: [String: Any]? = nil
    }

    // when
    analytics.log(type: Dummy())

    // then
    expect(self.firebase.logEventCallCount) == 1
    expect(self.firebase.logEventArgValues.first?.0) == "sonny"
    expect(self.firebase.logEventArgValues.first?.1).to(beNil())
  }

  func test_eventName_parameter가_존재하는_경우() {
    // given
    struct Dummy: PBAnalyticsType {
      let name = "sonny"
      let parameters: [String: Any]? = ["string": "string"]
    }

    // when
    analytics.log(type: Dummy())

    // then
    let parameter = firebase.logEventArgValues.first!.1!

    expect(self.firebase.logEventCallCount) == 1
    expect(self.firebase.logEventArgValues.first?.0) == "sonny"
    expect(parameter["string"] as? String) == "string"
  }

  func test_eventName_parameter가_다른타입으로_여러개_존재하는_경우() {
    // given
    struct Dummy: PBAnalyticsType {
      let name = "sonny"
      let parameters: [String: Any]? = [
        "string": "string",
        "int": 1
      ]
    }

    // when
    analytics.log(type: Dummy())

    // then
    let parameter = firebase.logEventArgValues.first!.1!

    expect(self.firebase.logEventCallCount) == 1
    expect(self.firebase.logEventArgValues.first?.0) == "sonny"
    expect(parameter["string"] as? String) == "string"
    expect(parameter["int"] as? Int) == 1
  }
}
