import Foundation

import Moya
import RxMoya
import RxSwift

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
      .flatMap {
        // 401(Unauthorized) 발생 시 자동으로 토큰을 재발급 받는다
        if $0.statusCode == 401 {
          throw PBNetworkError.tokenExpired
        } else {
          return Single.just($0)
        }
      }
      .retry { (error: Observable<PBNetworkError>) in
        error.flatMap { [weak self] error -> Single<Response> in
          guard let self else { return .error(PBNetworkError.unknown) }

          if error == .tokenExpired {
            return self.requestToken()
          }

          return .error(PBNetworkError.unknown)
        }
      }
      .handleResponse()
      .filterSuccessfulStatusCodes()
      .retry(2)
  }

  func requestToken() -> Single<Response> {
    .just(.init(statusCode: 200, data: Data()))
  }
}

/// 서버에서 보내주는 오류 문구 파싱용
extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
  func handleResponse() -> Single<Element> {
    return flatMap { response in

      // TODO: Token관련 API 작업되면 대응 필요
      if let _ = try? response.map(Token.self) {
        // UserDefaults.accessToken = newToken.accessToken
        // UserDefaults.refreshToken = newToken.refreshToken
      }

      if (200...299) ~= response.statusCode {
        return Single.just(response)
      }

      // TODO: Server에서 에러타입 정리되면 맞춰서 대응 필요
      let jsonDecoder = JSONDecoder()
      if let error = try? jsonDecoder.decode(ServerErrorDTO.self, from: response.data) {
        return Single.error(PBNetworkError.serverError(code: error.code, message: error.message))
      }

      return Single.error(PBNetworkError.unknown)
    }
  }
}
