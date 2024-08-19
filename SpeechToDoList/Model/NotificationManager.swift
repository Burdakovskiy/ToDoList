//
//  NotificationManager.swift
//  SpeechToDoList
//
//  Created by Дмитрий on 19.08.2024.
//

import UIKit

final class NotificationManager {
    static func scheduleNotification(at date: Date, with description: String) {
        let content = UNMutableNotificationContent()
        content.title = "To Do List"
        content.body = description
        
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}
