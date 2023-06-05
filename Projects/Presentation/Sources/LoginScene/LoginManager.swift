import Foundation
import UIKit

import AuthenticationServices
import GoogleSignIn
import RxSwift

// MARK: - LoginManagerProtocol

protocol LoginManagerProtocol: AnyObject {
  func login(with social: SocialLogin)
}

// MARK: - SocialLogin

public enum SocialLogin {
  case google
  case apple
}

// MARK: - LoginManagerDelegate

protocol LoginManagerDelegate: AnyObject {
  func loginManager(_ type: SocialLogin, didSucceedWithResult result: [String: String])
  func loginManager(didFailWithError error: Error)
}

// MARK: - LoginManager

final class LoginManager: NSObject, LoginManagerProtocol {
  private let disposeBag = DisposeBag()

  weak var viewController: UIViewController?
  weak var delegate: LoginManagerDelegate?

  func login(with social: SocialLogin) {
    switch social {
    case .apple:
      return appleLogin()
    case .google:
      return googleLogin()
    }
  }
}

// MARK: ASAuthorizationControllerPresentationContextProviding

extension LoginManager {
  private func googleLogin() {
    guard let viewController else { return }
    GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
      if let error {
        self.delegate?.loginManager(didFailWithError: error)
      }
      if let accessToken = result?.user.accessToken {
        self.delegate?.loginManager(
          .google,
          didSucceedWithResult: ["accessToken": accessToken.tokenString]
        )
      }
    }
  }

  private func appleLogin() {
    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]

    let authorizationController = ASAuthorizationController(authorizationRequests: [request])

    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
  }
}

// MARK: ASAuthorizationControllerDelegate

extension LoginManager: ASAuthorizationControllerDelegate {
  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    switch authorization.credential {
    case let appleIdCredential as ASAuthorizationAppleIDCredential:
      validateAppleIdCredential(appleIdCredential)
    case let passwordCredential as ASPasswordCredential:
      handlePasswordCredential(passwordCredential)
    default:
      break
    }
  }

  func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    handleAuthorizeError(error: error)
  }

  private func validateAppleIdCredential(_ credential: ASAuthorizationAppleIDCredential) {
    guard let identityToken = credential.identityToken,
          let token = String(data: identityToken, encoding: .utf8),
          let authorizationCode = credential.authorizationCode,
          let code = String(data: authorizationCode, encoding: .utf8) else { return }

    delegate?.loginManager(.apple, didSucceedWithResult: [
      "identityToken": token,
      "authorizationCode": code
    ])
  }

  private func handlePasswordCredential(_ credential: ASPasswordCredential) {
    // TODO: handle password
    _ = credential.user
    _ = credential.password
  }

  private func handleAuthorizeError(error: Error) {
    delegate?.loginManager(didFailWithError: error)
  }
}

// MARK: ASAuthorizationControllerPresentationContextProviding

extension LoginManager: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    viewController!.view.window!
  }
}
