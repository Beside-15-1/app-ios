import Foundation

import PBAnalyticsInterface

// MARK: - LoginEvent

enum LoginEvent {
  case click(component: String)
}

// MARK: PBAnalyticsType

extension LoginEvent: PBAnalyticsType {
  var name: String {
    switch self {

    case .click:
      return PBAnalyticsEventNameBuilder()
        .action(with: .clicked)
        .screen(with: "login")
        .version(with: 1)
        .build()
    }
  }

  var parameters: [String: Any]? {
    switch self {
    case .click(let component):
      return PBAnalyticsParameterBuilder()
        .component(with: component)
        .build()
    }
  }
}
