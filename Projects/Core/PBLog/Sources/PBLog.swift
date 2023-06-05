import Foundation

// MARK: - PBLogLevel

public enum PBLogLevel: String {
  case error
  case warning
  case info
  case debug
}

// MARK: - PBLog

public enum PBLog {
  public static func error(_ message: String) {
    log(level: .error, message: message)
  }

  public static func warning(_ message: String) {
    log(level: .warning, message: message)
  }

  public static func info(_ message: String) {
    log(level: .info, message: message)
  }

  public static func debug(_ message: String) {
    log(level: .debug, message: message)
  }

  private static func log(level: PBLogLevel, message: String) {
    print("\(Date()) [\(level.rawValue.uppercased())]: \(message)")
  }
}
