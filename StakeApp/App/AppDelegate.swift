import UIKit
import Firebase
import FirebaseMessaging
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        requestPushPermissionsIfNeeded()
        return true
    }

    func requestPushPermissionsIfNeeded() {
        let alreadySent = UserDefaults.standard.bool(forKey: "pushTokenSent")

        guard !alreadySent else { return }

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let token = fcmToken, !token.isEmpty else { return }

        let alreadySent = UserDefaults.standard.bool(forKey: "pushTokenSent")
        guard !alreadySent else { return }

        sendTokenToBackend(token) {
            UserDefaults.standard.set(true, forKey: "pushTokenSent")
        }
    }

    func sendTokenToBackend(_ token: String, completion: @escaping () -> Void) {
        guard let url = URL(string: "https://bovagames.fun/fcm/register") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload = ["token": token]
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: request) { _, _, _ in
            completion()
        }.resume()
    }

}
