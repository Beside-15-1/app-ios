import Foundation

public enum ActionType: String, Hashable {
  case clicked
  case shown
  case typed
  case impressed
  case left
  case longPressed
  case opened
  case received
}

public class PBAnalyticsEventNameBuilder {
  private var name = "client"

  private var action = ""
  private var screen = ""
  private var version = "v1"

  public init() {}

  public func action(with action: ActionType) -> PBAnalyticsEventNameBuilder {
    self.action = action.rawValue
    return self
  }

  public func screen(with screen: String) -> PBAnalyticsEventNameBuilder {
    self.screen = screen
    return self
  }

  public func version(with version: Int) -> PBAnalyticsEventNameBuilder {
    self.version = "v\(version)"
    return self
  }

  public func build() -> String {
    assert(!action.isEmpty, "액션 타입을 필수로 입력해주세요!")
    assert(!screen.isEmpty, "화면 이름을 필수로 입력해주세요!")
    assert(!screen.contains(where: { $0 == "_" }), "카멜 케이스로 작성해주세요!")

    return [
      name,
      action,
      screen,
      version
    ].joined(separator: "_")
  }
}
