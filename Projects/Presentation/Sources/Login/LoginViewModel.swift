//
//  LoginViewModel.swift
//  PresentationInterface
//
//  Created by 박천송 on 2023/04/27.
//

import Foundation

import RxSwift
import UIKit

import AuthenticationServices
import Domain

// MARK: - LoginViewModelInput

protocol LoginViewModelInput {
  func appleLoginButtonTapped()
}

// MARK: - LoginViewModelOutput

protocol LoginViewModelOutput {}

// MARK: - LoginViewModel

final class LoginViewModel {
  private let guideUseCase: GuideUseCase

  weak var loginViewController: LoginViewController?

  private let disposeBag = DisposeBag()

  init(guideUseCase: GuideUseCase) {
    self.guideUseCase = guideUseCase
  }
}

// MARK: LoginViewModelInput

extension LoginViewModel: LoginViewModelInput {
  func appleLoginButtonTapped() {
    guard let loginViewController else { return }

    let appleIDProvider = ASAuthorizationAppleIDProvider()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]

    let authorizationController = ASAuthorizationController(authorizationRequests: [request])
    authorizationController.delegate = loginViewController
    authorizationController.presentationContextProvider = loginViewController
    authorizationController.performRequests()
  }

  func validateAppleIdCredential(_ credential: ASAuthorizationAppleIDCredential) {
    guard let token = credential.identityToken else { return }
    let userIdentifier = credential.user
    let fullName = credential.fullName
    let email = credential.email

    let url = URL(string: "http://49.50.165.241/api/auth/apple")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let requestBody: [String: Any] = [
      "token": token.base64EncodedString(),
      "userIdentifier": userIdentifier,
      "fullName": fullName?.description ?? "",
      "email": email ?? ""
    ]
    let requestBodyData = try? JSONSerialization.data(withJSONObject: requestBody, options: [])
    request.httpBody = requestBodyData

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
      guard let data, error == nil else {
        return
      }

      if let httpResponse = response as? HTTPURLResponse,
         httpResponse.statusCode == 200 {
        do {
          let decoder = JSONDecoder()
          let _ = try decoder.decode(LoginResponse.self, from: data)
        } catch {
          print("Error decoding server response: \(error.localizedDescription)")
        }
      } else {
        // 검증 실패
      }
    }
    task.resume()
  }

  func handlePasswordCredential(_ credential: ASPasswordCredential) {
    let _ = credential.user
    let _ = credential.password
  }
}
