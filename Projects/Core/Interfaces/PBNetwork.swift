//
//  Network.swift
//  Core
//
//  Created by Hohyeon Moon on 2023/04/29.
//

import Foundation
import Moya

public protocol PBNetwork {
  func request<T: Decodable>(
    _ target: TargetType,
    completion: @escaping (Result<T, Error>) -> Void
  )
}
