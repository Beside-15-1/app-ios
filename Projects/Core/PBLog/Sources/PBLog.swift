import Foundation

import SwiftyJSON

// MARK: - PBLogLevel

public enum PBLogLevel: String {
  case error
  case warning
  case info
  case debug
}

// MARK: - PBLog

public enum PBLog {
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

  public static func api(_ url: URL?, _ response: JSON) {
    if let error = response["error"].string {
      print("\(Date().toString()) [❗️Failure]: Request: \(url?.description ?? "")\n Error: \(error)")
    }

    print("\(Date().toString()) [✅Success]: Request: \(url?.description ?? "")\n Response: \(response)")
  }

  private static func log(level: PBLogLevel, message: Any) {
    print("\(Date().toString()) [\(level.rawValue.uppercased())]: \(message)")
  }

  static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
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
    PBLog.dateFormatter.string(from: self as Date)
  }
}
