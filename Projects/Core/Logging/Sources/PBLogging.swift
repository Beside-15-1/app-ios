import Firebase

struct PBLogging {
  static func logEvent(eventName: String, parameters: [String: Any]?) {
    Analytics.logEvent(eventName, parameters: parameters)
  }
  
  static func setUserProperty(value: String, forName: String) {
    Analytics.setUserProperty(value, forName: forName)
  }
  
  static func setUserID(userID: String) {
    Analytics.setUserID(userID)
  }
  
  static func setScreenName(screenName: String, screenClass: String?) {
    Analytics.setScreenName(screenName, screenClass: screenClass)
  }
}

