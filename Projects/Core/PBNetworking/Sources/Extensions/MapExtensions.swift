import Foundation

import Moya
import RxSwift

import PBLog

private extension Moya.Response {
  func map<D: Decodable>(_ type: D.Type) throws -> D {
    let decoder = JSONDecoder()

    do {
      return try decoder.decode(D.self, from: data)
    } catch {
      Log.error("\(D.self) 디코딩에 실패했어요")
      throw PBNetworkError.decodingError
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
