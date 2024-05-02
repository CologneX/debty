//
//  AppDelegate.swift
//  Debty
//
//  Created by Kyrell Leano Siauw on 28/04/24.
//
import UIKit
import UserNotifications
import Firebase
import FirebaseMessaging
class AppDelegateNew: UIResponder, UIApplicationDelegate {
    
    // MARK:  Stored properties
    var window: UIWindow?
    
    private let notificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Register for remote notifications
        registerForPushNotifications()
        
        // Initialize Firebase
        FirebaseApp.configure()
        
        // Register for FCM token
        Messaging.messaging().delegate = self
        Messaging.messaging().token { token, error in
            if let token = token {
                UserDefaults.standard.set(token, forKey: "deviceToken")
            }
        }
        
        return true
    }
}
// MARK:  Application Lifecycle methods
extension AppDelegateNew {
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
}
// MARK:  Notification methods
extension AppDelegateNew: UNUserNotificationCenterDelegate {
    /// Requests the user for Push Notification access
    private func registerForPushNotifications() {
        // Setting delegate to listen to events
        notificationCenter.delegate = self
        /// Perform some notification registration magic !!!
        // Requesting access from user
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            // Checking if access is granted
            guard granted else { return }
            // Registering for remote notifications
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        /// We receive the device token that we requested
        /// We save the device token to our local storage of choice
        /// (If needed) We register the device token with our FCM
    }
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        /// Some error occured while registering for device token
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        /// 1. Called when the user taps on a notification and the app is opened
        /// 2. Responds to the custom actions linked with the notifications (like categories and actions used for notifications)
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        /// Called when the app is in foreground and the notification arrives
    }
}

extension AppDelegateNew: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken = fcmToken {
            UserDefaults.standard.set(fcmToken, forKey: "deviceToken")
        }
    }
}
