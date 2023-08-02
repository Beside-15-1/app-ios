import Foundation

public protocol PBAnalyticsType {
  var name: String { get }
  var parameters: [String: Any]? { get }
}
