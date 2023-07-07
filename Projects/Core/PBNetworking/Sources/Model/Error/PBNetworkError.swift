import Foundation

public enum PBNetworkError: Error, Equatable {
  case serverError(message: String)
  case tokenExpired
  case unknown
  case decodingError
}
