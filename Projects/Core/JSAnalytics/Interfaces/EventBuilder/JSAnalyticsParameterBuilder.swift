//
//  JSAnalyticsParameterBuilder.swift
//  JSAnalyticsInterface
//
//  Created by 박천송 on 2023/05/12.
//

import Foundation

public class JSAnalyticsParameterBuilder {
  private var parameters: [String: Any] = [:]

  public init() {}

  public func action(with action: JSAnalyticsActionType) -> JSAnalyticsParameterBuilder {
    parameters["actionType"] = action.rawValue
    return self
  }

  public func component(with component: String) -> JSAnalyticsParameterBuilder {
    parameters["component"] = component
    return self
  }

  public func set(key: String, value: Any) -> JSAnalyticsParameterBuilder {
    parameters[key] = value
    return self
  }

  public func build() -> [String: Any] {
    return parameters
  }
}
