//
//  AppDelegate.swift
//  LeaveCasa
//
//  Created by acme on 08/09/22.
//

import UIKit
import UserNotifications
import IQKeyboardManagerSwift
import Firebase
import FirebaseAuth
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        IQKeyboardManager.shared.enable = true
        
        // For iOS 10 display notificaJtion (sent via APNS)
      
        //MARK: Set Text Feild Indicater Color
        
        //Thread.sleep(forTimeInterval: 0.5)
        UITextField.appearance().tintColor = .theamColor()
        
        //MARK: Firebase Configure
        
        // Configure Firebase
        FirebaseApp.configure()
        
        // Register for notifications.
        Messaging.messaging().delegate = self
        registerForPushNotifications(application: application)
        return true
        
    }
    
    func registerForPushNotifications(application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in
                    application.registerForRemoteNotifications()
                    Messaging.messaging().delegate = self
                })
        }
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

// MARK: - NOTIFICATIONS DELEGATE
extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(fcmToken ?? "")")
        Cookies.saveDeviceToken(token: fcmToken ?? "")
        Messaging.messaging().token { token, error in
            if let error = error {
                debugPrint("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                debugPrint("FCM registration token: \(token)")
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        debugPrint(token)
        Messaging.messaging().apnsToken = deviceToken
        Auth.auth().setAPNSToken(deviceToken, type: .prod)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        debugPrint("error")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
       // let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        //homeViewControllerDelegate?.updateNotifications()
        completionHandler([.alert, .sound, .badge])
    }
}
