//
//  PBNetwork.swift
//  Core
//
//  Created by Hohyeon Moon on 2023/04/30.
//

import CoreInterface
import Foundation
import Moya
import RxMoya
import RxSwift

class PBNetworkImpl: PBNetwork {
  private let disposeBag = DisposeBag()
  private let provider = MoyaProvider<PBAPI>()

  func request(
    _ target: TargetType,
    completion: @escaping (Result<Response, Error>) -> Void
  ) {
    provider.rx.request(.createUser(name: "Hohyeon", email: "hohyeonmoon@gmail.com"))
      .subscribe { result in
        completion(result)
      }
      .disposed(by: disposeBag)
  }
}
