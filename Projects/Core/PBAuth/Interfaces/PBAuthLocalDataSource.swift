import Foundation

// MARK: - PBAuthLocalDataSource

/// @mockable
public protocol PBAuthLocalDataSource {
  var accessToken: String? { get set }
  var refreshToken: String? { get set }

  var social: String? { get set }
  var email: String? { get set }
}
