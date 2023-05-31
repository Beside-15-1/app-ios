//
//  JSNetworkError.swift
//  NetworkingInterface
//
//  Created by 박천송 on 2023/05/12.
//

import Foundation

public enum PBNetworkError: Error, Equatable {
  case serverError(code: String, message: String)
  case tokenExpired
  case unknown
  case decodingError
}
