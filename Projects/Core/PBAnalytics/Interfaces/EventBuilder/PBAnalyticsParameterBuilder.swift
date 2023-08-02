import Foundation

public class PBAnalyticsParameterBuilder {
  private var parameters: [String: Any] = [:]

  public init() {}

  public func action(with action: PBAnalyticsActionType) -> PBAnalyticsParameterBuilder {
    parameters["actionType"] = action.rawValue
    return self
  }

  public func component(with component: String) -> PBAnalyticsParameterBuilder {
    parameters["component"] = component
    return self
  }

  public func set(key: String, value: Any) -> PBAnalyticsParameterBuilder {
    parameters[key] = value
    return self
  }

  public func build() -> [String: Any] {
    return parameters
  }
}
