//
//  LoginManager.swift
//  LoginManagerInterface
//
//  Created by 박천송 on 2023/05/04.
//

import Foundation
import UIKit

import RxSwift

public protocol LoginManager {
  func login(with social: SocialLogin) -> Single<String>
}
