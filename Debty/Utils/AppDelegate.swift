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
import AVFoundation
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK:  Stored properties
    let speechSynthesizer = AVSpeechSynthesizer()
    var window: UIWindow?
    let audioSession = AVAudioSession.sharedInstance()
    private let notificationCenter = UNUserNotificationCenter.current()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
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
        // Configure audio session
        do {
            try audioSession.setCategory(.playback, mode: .voicePrompt, options: [])
            try audioSession.setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
        return true
    }
    
//    private func configureNearbyInteraction() {
//            let configuration = NINearbyPeerConfiguration(peerToken: nil)
//            session = NISession(configuration: configuration)
//            session?.delegate = self
//    }
}


// MARK:  Application Lifecycle methods
extension AppDelegate {
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
        do {
            try audioSession.setCategory(.playback, mode: .voicePrompt, options: [])
            try audioSession.setActive(true)
        } catch {
            print("Failed to configure audio session: \(error)")
        }
    }
}
// MARK: Audio Session methods
extension AppDelegate: AVAudioPlayerDelegate {
}
// MARK:  Notification methods
extension AppDelegate: UNUserNotificationCenterDelegate {
    
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
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken;
    }
    
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        /// Some error occured while registering for device token
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // Text-to-speech functionality should be moved after scheduling notification
        if let avmessage = userInfo["avmessage"] as? String {
            let utterance = AVSpeechUtterance(string: avmessage)
            utterance.pitchMultiplier = 1.0
            utterance.rate = 0.5
            utterance.voice = AVSpeechSynthesisVoice(language: "id-ID")
            // change the
            speechSynthesizer.speak(utterance)
        }
        
        // Call completion handler after speaking
        completionHandler(UIBackgroundFetchResult.newData)
        
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("pas tekan")
        let userInfo = response.notification.request.content.userInfo
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken = fcmToken {
            UserDefaults.standard.set(fcmToken, forKey: "deviceToken")
        }
    }
}
