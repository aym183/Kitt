//
//  MishkiApp.swift
//  Mishki
//
//  Created by Ayman Ali on 09/05/2023.
//

import SwiftUI
import Firebase
import GoogleSignIn
import UserNotifications
import FirebaseMessaging
import UIKit

class AppState: ObservableObject {
    static let shared = AppState()
    @Published var pageToNavigationTo : String?
}

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, ObservableObject  {
    var isSignedUp = false
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            FirebaseApp.configure()
            return true
       }
    
    func registerPushNotifications() {
        let center = UNUserNotificationCenter.current()
           center.delegate = self
           center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
               if granted {
                   self.isSignedUp = true
                   DispatchQueue.main.async {
                       UIApplication.shared.registerForRemoteNotifications()
                   }
               }
           }
        Messaging.messaging().delegate = self
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            let userInfo = notification.request.content.userInfo
            completionHandler([.alert, .badge, .sound])
        }
        
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            let userInfo = response.notification.request.content.userInfo
            AppState.shared.pageToNavigationTo = "LandingPage"
            completionHandler()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
           Messaging.messaging().apnsToken = deviceToken
       }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
            @AppStorage("fcm_token") var cached_fcm: String = ""
            if fcmToken != cached_fcm {
                UserDefaults.standard.set(fcmToken, forKey: "fcm_token")
                UpdateDB().updateFCM(fcm: cached_fcm)
            }
        }
}

@main
struct KittAPP: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            LandingPage().preferredColorScheme(.dark)
        }
    }
}
