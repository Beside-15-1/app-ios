import Foundation

import Moya
import RxMoya
import RxSwift
import SwiftyJSON

import PBLog

// MARK: - PBNetworking

public final class PBNetworking<T: TargetType> {
  private let provider: MoyaProvider<T>

  public init(isStub: Bool = false) {
    if isStub {
      provider = MoyaProvider<T>(stubClosure: { MoyaProvider.immediatelyStub($0) })
    } else {
      provider = MoyaProvider<T>()
    }
  }

  public func request(target: T) -> Single<Response> {
    provider.rx.request(target)
      .handleResponse()
      .filterSuccessfulStatusCodes()
  }

  func requestToken() -> Single<Response> {
    .just(.init(statusCode: 200, data: Data()))
  }
}

/// 서버에서 보내주는 오류 문구 파싱용
extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
  func handleResponse() -> Single<Element> {
    return flatMap { response in

      PBLog.api(response.request?.url, JSON(response.data))

      if (200...299) ~= response.statusCode {
        return Single.just(response)
      }

      // TODO: Server에서 에러타입 정리되면 맞춰서 대응 필요
      let jsonDecoder = JSONDecoder()
      if let error = try? jsonDecoder.decode(PBServerErrorDTO.self, from: response.data) {
        return Single.error(PBNetworkError.serverError(code: error.code, message: error.message))
      }

      return Single.error(PBNetworkError.unknown)
    }
  }
}
