// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import UserNotifications

@available(iOS 13.0, *)
public class NotificationManager: ObservableObject {
    
    public static let shared = NotificationManager()
    
    public func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission granted")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func setupContent(title: String, subtitle: String?, body: String, sound: UNNotificationSound?) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle ?? ""
        content.body = body
        content.sound = sound ?? UNNotificationSound.default
        
        return content
    }
    
    func scheduleNotification(identifier: String?, content: UNMutableNotificationContent, trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(identifier: identifier ?? UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Notification scheduled")
            }
        }
    }
    
    public func scheduleTimeIntervalNotification(identifier: String?, title: String, subtitle: String?, body: String, sound: UNNotificationSound?, interval: TimeInterval, repeats: Bool) {
        let content = setupContent(title: title, subtitle: subtitle, body: body, sound: sound)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: repeats)
        
        scheduleNotification(identifier: identifier, content: content, trigger: trigger)
    }
    
    public func scheduleDailyNotification(identifier: String?, title: String, subtitle: String?, body: String, sound: UNNotificationSound?, hour: Int, minute: Int?, second: Int?, repeats: Bool) {
        let content = setupContent(title: title, subtitle: subtitle, body: body, sound: sound)
        var date = DateComponents()
        date.hour = hour
        if minute != nil {
            date.minute = minute
        }
        if second != nil {
            date.second = second
        }
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: repeats)
        
        scheduleNotification(identifier: identifier, content: content, trigger: trigger)
    }
}
