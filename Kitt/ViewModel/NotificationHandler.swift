//
//  NotificationHandler.swift
//  Kitt
//
//  Created by Ayman Ali on 11/06/2023.
//

import Foundation
import UserNotifications

struct NotificationHandler {
    func scheduleLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Notification Title Ayman"
        content.body = "Notification Body"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "notificationIdentifier", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                // Failed to schedule the notification
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                // Notification scheduled successfully
            }
        }
    }

}
