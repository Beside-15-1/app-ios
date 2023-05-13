//
//  MapExtensions.swift
//  NetworkingInterface
//
//  Created by 박천송 on 2023/05/11.
//

import Foundation

import Moya
import RxSwift

private extension Moya.Response {
  func map<D: Decodable>(_ type: D.Type) throws -> D {
    let decoder = JSONDecoder()

    do {
      return try decoder.decode(D.self, from: data)
    } catch {
      throw JSNetworkError.decodingError
    }
  }
}

public extension PrimitiveSequence where Trait == SingleTrait, Element == Moya.Response {
  func map<D: Decodable>(
    _ type: D.Type
  ) -> Single<D> {
    return flatMap {
      try .just($0.map(type))
    }
  }
}
