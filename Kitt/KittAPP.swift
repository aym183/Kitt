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


class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate  {
    var isNotificationReceived = false
    
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
           
//            if let notification = launchOptions?[.remoteNotification] as? [String: Any] {
//                        // Handle the notification and navigate the user to view X
////                        handleNotification(notification)
//                print("I Came from noti")
//            }
            Messaging.messaging().delegate = self

            return true
       }
    
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

//extension AppDelegate: UNUserNotificationCenterDelegate {
//  // Receive displayed notifications for iOS 10 devices.
//
//}


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

struct LandingPage: View {
//    @ObservedObject var appState = AppState.shared
    @AppStorage("username") var userName: String = ""
    @State var loggedInUser = false
    @State var isNotificationReceived = false
//    @EnvironmentObject var notificationState: NotificationState
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
//                    if Auth.auth().currentUser != nil && appState.pageToNavigationTo != nil {
//                        HomePage(isSignedUp: false, isShownHomePage: true, isChangesMade: false, isShownClassCreated: false, isShownProductCreated: false, isShownLinkCreated: false, isShownFromNotification: true)
//                    } else
                    if Auth.auth().currentUser != nil {
                        HomePage(isSignedUp: false, isShownHomePage: true, isChangesMade: false, isShownClassCreated: false, isShownProductCreated: false, isShownLinkCreated: false, isShownFromNotification: false)
                    } else {
                        LandingContent()
                    }
                }
            }
        }
    }
}

