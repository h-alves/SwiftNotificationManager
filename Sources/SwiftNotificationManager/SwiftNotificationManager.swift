// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import UserNotifications
import CoreLocation

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
    
    func setupContent(title: String, subtitle: String? = "", body: String, sound: UNNotificationSound? = UNNotificationSound.default) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subtitle ?? ""
        content.body = body
        content.sound = sound ?? UNNotificationSound.default
        
        return content
    }
    
    func scheduleNotification(identifier: String = UUID().uuidString, content: UNMutableNotificationContent, trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Notification scheduled")
            }
        }
    }
    
    public func scheduleTimeIntervalNotification(identifier: String = UUID().uuidString, title: String, subtitle: String = "", body: String, sound: UNNotificationSound = UNNotificationSound.default, interval: TimeInterval, repeats: Bool) {
        let content = setupContent(title: title, subtitle: subtitle, body: body, sound: sound)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: repeats)
        
        scheduleNotification(identifier: identifier, content: content, trigger: trigger)
    }
    
    public func scheduleDailyNotification(identifier: String = UUID().uuidString, title: String, subtitle: String = "", body: String, sound: UNNotificationSound = UNNotificationSound.default, hour: Int, minute: Int? = 0, second: Int? = 0, repeats: Bool) {
        let content = setupContent(title: title, subtitle: subtitle, body: body, sound: sound)
        
        var date = DateComponents()
        date.hour = hour
        date.minute = minute
        date.second = second
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: repeats)
        
        scheduleNotification(identifier: identifier, content: content, trigger: trigger)
    }
    
    public func scheduleLocationNotification(identifier: String = UUID().uuidString, title: String, subtitle: String = "", body: String, sound: UNNotificationSound? = UNNotificationSound.default, latitude: Double, longitude: Double, radius: Double = 2000.0, placeID: String, repeats: Bool) {
        let content = setupContent(title: title, subtitle: subtitle, body: body, sound: sound)
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = CLCircularRegion(center: center, radius: radius, identifier: placeID)
        
        region.notifyOnEntry = true
        region.notifyOnExit = false
        
        let trigger = UNLocationNotificationTrigger(region: region, repeats: repeats)
        
        scheduleNotification(identifier: identifier, content: content, trigger: trigger)
    }
    
    public func cancelAllPendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    public func cancelPendingNotification(identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
}
