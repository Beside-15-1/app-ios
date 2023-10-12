import UIKit

import FirebaseCore
import FirebaseMessaging
import PBLog

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  let dependency: AppDependency

  override private init() {
    self.dependency = AppAssembly.resolve()
    super.init()
  }

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    dependency.configureFirebase()

    configureNotification(application)

    Messaging.messaging().delegate = self
    
    return true
  }
}

extension AppDelegate {
  private func configureNotification(_ application: UIApplication) {
    UNUserNotificationCenter.current().delegate = self

    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(
      options: authOptions,
      completionHandler: { _, _ in }
    )

    application.registerForRemoteNotifications()
  }
}

extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {

  public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    let firebaseToken = fcmToken ?? ""
    print("firebase token: \(firebaseToken)")
  }

  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    // 이 메서드가 호출될 때, deviceToken을 FCM에 등록해야 합니다.
    Messaging.messaging().apnsToken = deviceToken
  }

  public func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    completionHandler([.badge, .sound])
  }

  public func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    completionHandler()
  }
}
