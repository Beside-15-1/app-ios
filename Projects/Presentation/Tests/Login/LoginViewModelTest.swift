import XCTest

import Nimble

import DomainTesting
import PBAnalyticsTesting
@testable import Presentation

// MARK: - LoginViewModelTest

final class LoginViewModelTest: XCTestCase {
  var analytics: PBAnalyticsMock!
  var loginManager: LoginManagerMock!
  var googleLoginUseCase: GoogleLoginUseCaseMock!
  var appleLoginUseCase: AppleLoginUseCaseMock!

  override func setUp() {
    super.setUp()

    analytics = .init()
    loginManager = .init()
    googleLoginUseCase = .init()
    appleLoginUseCase = .init()
  }

  private func createViewModel() -> LoginViewModel {
    .init(
      analytics: analytics,
      loginManager: loginManager,
      googleLoginUseCase: googleLoginUseCase,
      appleLoginUseCase: appleLoginUseCase
    )
  }
}

// MARK: - GoogleLogin

extension LoginViewModelTest {
  func test_googleLoginButtonTapped_loginManager를_통해_로그인을_시도해요() {
    // given
    let viewModel = createViewModel()

    // when
    viewModel.googleLoginButtonTapped()

    // then
    expect(self.loginManager.loginCallCount) == 1
    expect(self.loginManager.loginArgValues.first) == .google
  }

  func test_googleLoginButtonTapped_소셜로그인에_성공하면_서비스_로그인을_시도해요_성공하면_isLoginSuccess_상태를_변경해요() {
    // given
    let viewModel = createViewModel()
    loginManager.loginHandler = { socialLogin in
      viewModel.loginManager(socialLogin, didSucceedWithResult: ["accessToken": "sonny"])
    }
    googleLoginUseCase.excuteHandler = { _ in
      .just(true)
    }

    // when
    viewModel.googleLoginButtonTapped()

    // then
    expect(viewModel.isLoginSuccess.value) == true
  }

  func test_googleLoginButtonTapped_소셜로그인에_성공하면_서비스_로그인을_시도해요_실패하면_isLoginSuccess_상태를_변경해요() {
    // given
    let viewModel = createViewModel()
    loginManager.loginHandler = { socialLogin in
      viewModel.loginManager(socialLogin, didSucceedWithResult: ["accessToken": "sonny"])
    }
    googleLoginUseCase.excuteHandler = { _ in
      .error(NSError(domain: "", code: 200))
    }

    // when
    viewModel.googleLoginButtonTapped()

    // then
    expect(viewModel.error.value).toNot(beNil())
  }

  func test_googleLoginButtonTapped_소셜로그인에_실패하면_error상태를_변경해요() {
    // given
    let viewModel = createViewModel()
    loginManager.loginHandler = { _ in
      viewModel.loginManager(didFailWithError: NSError(domain: "", code: 200))
    }

    // when
    viewModel.googleLoginButtonTapped()

    // then
    expect(viewModel.error.value).toNot(beNil())
  }

  func test_googleLoginButtonTapped_이벤트를_로깅해요() {
    // given
    let viewModel = createViewModel()

    // when
    viewModel.googleLoginButtonTapped()

    // then
    expect(self.analytics.logArgValues.first).to(Predicate { expression in
      guard let event = try expression.evaluate() else {
        return PredicateResult(status: .fail, message: .fail("got nil"))
      }

      guard case LoginEvent.clickGoogleLogin = event else {
        return PredicateResult(status: .fail, message: .fail("got nil"))
      }

      return PredicateResult(status: .matches, message: .fail("got nil"))

    })
  }
}

// MARK: - AppleLogin

extension LoginViewModelTest {
  func test_appleLoginButtonTapped_loginManager를_통해_로그인을_시도해요() {
    // given
    let viewModel = createViewModel()

    // when
    viewModel.appleLoginButtonTapped()

    // then
    expect(self.loginManager.loginCallCount) == 1
    expect(self.loginManager.loginArgValues.first) == .apple
  }

  func test_appleLoginButtonTapped_소셜로그인에_성공하면_서비스_로그인을_시도해요_성공하면_isLoginSuccess_상태를_변경해요() {
    // given
    let viewModel = createViewModel()
    loginManager.loginHandler = { socialLogin in
      viewModel.loginManager(socialLogin, didSucceedWithResult: [
        "identityToken": "token",
        "authorizationCode": "code"
      ])
    }
    appleLoginUseCase.excuteHandler = { _ in
      .just(true)
    }

    // when
    viewModel.appleLoginButtonTapped()

    // then
    expect(viewModel.isLoginSuccess.value) == true
  }

  func test_appleLoginButtonTapped_소셜로그인에_성공하면_서비스_로그인을_시도해요_실패하면_isLoginSuccess_상태를_변경해요() {
    // given
    let viewModel = createViewModel()
    loginManager.loginHandler = { socialLogin in
      viewModel.loginManager(socialLogin, didSucceedWithResult: [
        "identityToken": "token",
        "authorizationCode": "code"
      ])
    }
    appleLoginUseCase.excuteHandler = { _ in
      .error(NSError(domain: "", code: 200))
    }

    // when
    viewModel.appleLoginButtonTapped()

    // then
    expect(viewModel.error.value).toNot(beNil())
  }

  func test_appleLoginButtonTapped_소셜로그인에_실패하면_error상태를_변경해요() {
    let viewModel = createViewModel()
    loginManager.loginHandler = { _ in
      viewModel.loginManager(didFailWithError: NSError(domain: "", code: 200))
    }

    // when
    viewModel.appleLoginButtonTapped()

    // then
    expect(viewModel.error.value).toNot(beNil())
  }

  func test_appleLoginButtonTapped_이벤트를_로깅해요() {
    // given
    let viewModel = createViewModel()

    // when
    viewModel.appleLoginButtonTapped()

    // then
    expect(self.analytics.logArgValues.first).to(Predicate { expression in
      guard let event = try expression.evaluate() else {
        return PredicateResult(status: .fail, message: .fail("got nil"))
      }

      guard case LoginEvent.clickAppleLogin = event else {
        return PredicateResult(status: .fail, message: .fail("got nil"))
      }

      return PredicateResult(status: .matches, message: .fail("got nil"))

    })
  }
}
