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

class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { success, _ in
            guard success else {
                return
            }
            print("Success in APNs registry")
        }
        application.registerForRemoteNotifications()
        return true
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) { messaging.token() { token, _ in
        guard let token = token else {
            print("Token is nil")
            return
        }
        print("Token: \(token)")
    }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Handle the notification and customize its presentation
        // You can specify how the notification should be presented to the user
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the notification and perform actions based on the user's response
        completionHandler()
    }

//    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//            @AppStorage("username") var username: String = ""
//            let databaseRef = Database.database().reference().child("sales").child(username)
//
//            databaseRef.observe(.value) { snapshot in
//
//                if snapshot.exists() {
//                    // Database has new data, trigger actions or update UI
////                    completionHandler(.newData)
//                    print("\(snapshot.value) This is snapshot value")
//                } else {
//                    // No new data
//                    completionHandler(.noData)
//                }
//            }
//        }
    
    
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
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
