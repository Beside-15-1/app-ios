import Foundation
@testable import Presentation

public final class LoginManagerMock: LoginManagerProtocol {
  public init() {}

  public private(set) var loginCallCount = 0
  public var loginArgValues = [SocialLogin]()
  public var loginHandler: ((SocialLogin) -> Void)?
  public func login(with social: SocialLogin) {
    loginCallCount += 1
    loginArgValues.append(social)
    if let loginHandler {
      return loginHandler(social)
    }
  }
}
