import Foundation

public enum PBNetworkError: Error, Equatable {
  case serverError(code: String, message: String)
  case tokenExpired
  case unknown
  case decodingError
}
