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

  func request<T: Decodable>(
    _ target: TargetType,
    completion: @escaping (Result<T, Error>) -> Void
  ) {
    provider.rx.request(.createUser(name: "Hohyeon", email: "hohyeonmoon@gmail.com"))
      .subscribe { result in
        switch result {
        case let .success(response):
          do {
            let decoder = JSONDecoder()
            let data = try decoder.decode(T.self, from: response.data)
            completion(.success(data))
          } catch {
            completion(.failure(error))
          }
        case let .failure(error):
          completion(.failure(error))
        }
      }
      .disposed(by: disposeBag)
  }
}
