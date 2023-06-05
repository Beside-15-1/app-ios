import Foundation

public class PBAnalyticsEventNameBuilder {
  private var name = "client"

  // Required
  private var screen = ""
  private var version = "v1"

  public init() {}

  public func screen(with screen: String) -> PBAnalyticsEventNameBuilder {
    self.screen = screen
    return self
  }

  public func version(with version: Int) -> PBAnalyticsEventNameBuilder {
    self.version = "v\(version)"
    return self
  }

  public func build() -> String {
    assert(!screen.isEmpty, "화면 이름을 필수로 입력해주세요!")
    assert(!screen.contains(where: { $0 == "_" }), "카멜 케이스로 작성해주세요!")

    return [
      name,
      screen,
      version
    ].joined(separator: "_")
  }
}
