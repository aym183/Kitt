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

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
           FirebaseApp.configure()
           
               let center = UNUserNotificationCenter.current()
               center.delegate = self
               center.requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
                   if granted {
                       DispatchQueue.main.async {
                           application.registerForRemoteNotifications()
                       }
                   }
               }
           
           Messaging.messaging().delegate = self

           return true
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

extension AppDelegate: UNUserNotificationCenterDelegate {
  // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    willPresent notification: UNNotification,
                                    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            let userInfo = notification.request.content.userInfo
            print(userInfo)
            completionHandler([.alert, .badge, .sound])
        }
        
        func userNotificationCenter(_ center: UNUserNotificationCenter,
                                    didReceive response: UNNotificationResponse,
                                    withCompletionHandler completionHandler: @escaping () -> Void) {
            let userInfo = response.notification.request.content.userInfo
            print(userInfo)
            completionHandler()
        }
}


extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
            @AppStorage("fcm_token") var cached_fcm: String = ""
        
            if fcmToken == cached_fcm {
                print("Cached registration token is: \(fcmToken ?? "")")
            } else {
                UserDefaults.standard.set(fcmToken, forKey: "fcm_token")
                print("New registration token is: \(fcmToken ?? "")")
            }
            // TODO: Send the fcmToken to your server if needed
        }
    
}


@main
struct KittAPP: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            LandingPage().preferredColorScheme(.dark)
        }
    }
}
