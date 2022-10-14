//
//  AppDelegate.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2022/09/09.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate{



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "완료"
        
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.sound, .badge, .alert]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        
        // 테스트위한 토큰 받는 코드
//        Messaging.messaging().token { token, error in
//          if let error = error {
//            print("Error fetching FCM registration token: \(error)")
//          } else if let token = token {
//            print("FCM registration token: \(token)")
//          }
//        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
}
extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    // 포그라운드 알림 수신 : 로컬 푸시 동일
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Setting 화면에 있다면 포그라운드 푸시 띄우지 마라! 여기서 구현
        
        completionHandler([.badge, .sound, .banner, .list])
        
    }
    
    // 푸시 클릭 -> 유저가 푸시를 클릭했을 때에만 수신 확인 가능
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        print("User Get Message")
        print(response.notification.request.content.body)
        print(response.notification.request.content.userInfo)
        
        
        //        guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
        //        print(viewController)
        //        if viewController is ViewController {
        //            viewController.navigationController?.pushViewController(SettingViewController(), animated: true)
        //        } else if viewController is ProfileViewController {
        //            viewController.dismiss(animated: true)
        //        } else if viewController is SettingViewController {
        //            viewController.navigationController?.popViewController(animated: true)
        //        }
    }
}
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")

        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
          name: Notification.Name("FCMToken"),
          object: nil,
          userInfo: dataDict
        )
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
}
