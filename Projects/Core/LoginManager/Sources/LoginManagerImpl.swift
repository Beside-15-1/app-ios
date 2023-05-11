//
//  LoginManager.swift
//  LoginManager
//
//  Created by 박천송 on 2023/05/04.
//

import Foundation
import UIKit

import GoogleSignIn
import RxSwift

import LoginManagerInterface

// MARK: - LoginManagerImpl

final class LoginManagerImpl: LoginManager {
  func login(with social: SocialLogin) -> Single<String> {
    switch social {
    case .apple:
      return Single.just("")
    case .google:
      return googleLogin()
    }
  }
}

extension LoginManagerImpl {
  private func googleLogin() -> Single<String> {
    guard let viewController = UIApplication.shared.windows.first?.rootViewController else {
      return .error(NSError(domain: "rootViewController", code: 0))
    }

    return .create { single -> Disposable in

      GIDSignIn.sharedInstance.signIn(withPresenting: viewController) { result, error in
        if let error {
          single(.failure(error))
        }

        if let accessToken = result?.user.accessToken {
          single(.success(accessToken.tokenString))
        }
      }

      return Disposables.create()
    }
  }
}
