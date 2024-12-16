import Foundation

import SwiftyJSON

// MARK: - PBLogLevel

public enum PBLogLevel: String {
  case error = "❗️ERROR "
  case warning = "⚠️WARNING "
  case info = "💙INFO"
  case debug
}

// MARK: - PBLog

public enum Log {
  public static func error(_ message: Any) {
    log(level: .error, message: message)
  }

  public static func warning(_ message: Any) {
    log(level: .warning, message: message)
  }

  public static func info(_ message: Any) {
    log(level: .info, message: message)
  }

  public static func debug(_ message: Any) {
    #if DEBUG
      log(level: .debug, message: message)
    #endif
  }

  public static func api(statusCode: Int, method: String, _ url: URL?, _ response: JSON) {
    if let error = response["error"].string {
      print("\(Date().toString()) [❗️Failure]: [StatusCode \(statusCode)] [\(method.uppercased())] \(url?.description ?? "")\n Error: \(error)")
    } else {
      print("\(Date().toString()) [✅Success]: [StatusCode \(statusCode)] [\(method.uppercased())] \(url?.description ?? "")\n Response: \(response)")
    }
  }

  private static func log(level: PBLogLevel, message: Any) {
    print("\(Date().toString()) [\(level.rawValue.uppercased())]: \(message)")
  }

  static var dateFormat = "yyyy-MM-dd hh:mm:ss"
  static var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = dateFormat
    formatter.locale = Locale.current
    formatter.timeZone = TimeZone.current
    return formatter
  }
}

extension Date {
  func toString() -> String {
    Log.dateFormatter.string(from: self as Date)
  }
}
