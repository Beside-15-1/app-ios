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

// MARK: - PBNetworkImpl

class PBNetworkImpl: PBNetwork {
  private let disposeBag = DisposeBag()
  private let provider = MoyaProvider<PBAPI>()

  func request(_ target: TargetType) -> Single<Result<Response, Error>> {
    provider.rx.request(.createUser(name: "", email: ""))
      .map { response in
        return .success(response)
      }
      .catch { error in
        return .error(error)
      }
  }
}

public extension Moya.Response {
  func map<D: Decodable>(_ type: D.Type) throws -> D {
    let decoder = JSONDecoder()

    do {
      return try decoder.decode(D.self, from: data)
    } catch {
      throw error
    }
  }
}
