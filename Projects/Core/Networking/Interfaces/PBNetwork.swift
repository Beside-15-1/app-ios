//
//  Network.swift
//  Core
//
//  Created by Hohyeon Moon on 2023/04/29.
//

import Foundation
import Moya
import RxSwift

public protocol PBNetwork {
  func request(_ target: TargetType) -> Single<Result<Response, Error>>
}
