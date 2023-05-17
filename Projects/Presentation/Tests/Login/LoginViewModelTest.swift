//
//  LoginViewModelTest.swift
//  PresantationManifests
//
//  Created by cheonsong on 2022/09/19.
//

import XCTest

import Nimble

import DomainTesting
@testable import Presentation

// MARK: - LoginViewModelTest

final class LoginViewModelTest: XCTestCase {
  var loginManager: LoginManagerMock!
  var googleLoginUseCase: GoogleLoginUseCaseMock!
  var appleLoginUseCase: AppleLoginUseCaseMock!

  override func setUp() {
    super.setUp()

    loginManager = .init()
    googleLoginUseCase = .init()
    appleLoginUseCase = .init()
  }

  private func createViewModel() -> LoginViewModel {
    .init(
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
      return .just("success")
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
      return .error(NSError(domain: "", code: 200))
    }

    // when
    viewModel.googleLoginButtonTapped()

    // then
    expect(viewModel.error.value).toNot(beNil())
  }

  func test_googleLoginButtonTapped_소셜로그인에_실패하면_error상태를_변경해요() {
    let viewModel = createViewModel()
    loginManager.loginHandler = { _ in
      viewModel.loginManager(didFailWithError: NSError(domain: "", code: 200))
    }

    // when
    viewModel.googleLoginButtonTapped()

    // then
    expect(viewModel.error.value).toNot(beNil())
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
    appleLoginUseCase.excuteHandler = { _, _ in
      return .just("success")
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
    appleLoginUseCase.excuteHandler = { _, _ in
      return .error(NSError(domain: "", code: 200))
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
}
