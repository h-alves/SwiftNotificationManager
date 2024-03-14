// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import UserNotifications
import CoreLocation

@available(iOS 13.0, *)
public class NotificationManager: ObservableObject {
    
    public static let shared = NotificationManager()
    
    let center = UNUserNotificationCenter.current()
    
    /**
        Request a person’s authorization to allow alerts, sounds and badges for local and remote notifications for your app.
    */
    public func requestPermission() {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
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
        
        center.add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Notification scheduled")
            }
        }
    }
    
    /**
        Schedules the delivery of a local notification with a Time Interval trigger.
     
        - Parameters:

            - identifier: A unique value to identify the notification's request. If left empty receives a string created from an UUID.
     
            - title: The localized text that provides the notification’s primary description.
     
            - subtitle: The localized text that provides the notification’s secondary description.
     
            - body: The localized text that provides the notification’s main content.
     
            - sound: The sound that plays when the system delivers the notification.
     
            - interval: The time interval required to create the trigger, displayed in seconds.
     
            - repeats: A Boolean value indicating whether the system reschedules the notification after it’s delivered.
     
        This method schedules local notifications only; you cannot use it to schedule the delivery of remote notifications. Upon calling this method, it creates a trigger with the time interval written in seconds, then the system begins tracking the trigger conditions associated with your request. When the trigger condition is met, the system delivers your notification.
     
        ````swift
        // Scheduling a local notification to fire in 60 seconds
        let manager = NotificationManager.shared
        manager.scheduleTimeIntervalNotification(
            title: "1 minute",
            body: "This notification was scheduled 60 seconds ago",
            interval: 60,
            repeats: false
        )
        ````
    */
    public func scheduleTimeIntervalNotification(identifier: String = UUID().uuidString, title: String, subtitle: String = "", body: String, sound: UNNotificationSound = UNNotificationSound.default, interval: TimeInterval, repeats: Bool) {
        let content = setupContent(title: title, subtitle: subtitle, body: body, sound: sound)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: repeats)
        
        scheduleNotification(identifier: identifier, content: content, trigger: trigger)
    }
    
    /**
        Schedules the delivery of a local notification with a Calendar trigger.
     
        - Parameters:

            - identifier: A unique value to identify the notification's request. If left empty receives a string created from an UUID.
     
            - title: The localized text that provides the notification’s primary description.
     
            - subtitle: The localized text that provides the notification’s secondary description.
     
            - body: The localized text that provides the notification’s main content.
     
            - sound: The sound that plays when the system delivers the notification.
     
            - date: The date components reffering to when the notification will be fired required to create the trigger.
     
            - repeats: A Boolean value indicating whether the system reschedules the notification after it’s delivered.
     
        This method schedules local notifications only; you cannot use it to schedule the delivery of remote notifications. Upon calling this method, it creates a trigger with the date written as dateComponents, then the system begins tracking the trigger conditions associated with your request. When the trigger condition is met, the system delivers your notification.
     
        ````swift
        // Scheduling a local notification to fire in a distant future
        let date = Date.distantFuture
    
        let manager = NotificationManager.shared
        manager.scheduleTimeIntervalNotification(
            title: "Distant future",
            body: "This notification was scheduled to trigger in a distant future",
            date: Calendar.current.dateComponents([.year, .month, .day], from: date)
            repeats: false
        )
        ````
    */
    public func scheduleCalendarNotification(identifier: String = UUID().uuidString, title: String, subtitle: String = "", body: String, sound: UNNotificationSound = UNNotificationSound.default, date: DateComponents, repeats: Bool) {
        let content = setupContent(title: title, subtitle: subtitle, body: body, sound: sound)
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: repeats)
        
        scheduleNotification(identifier: identifier, content: content, trigger: trigger)
    }
    
    /**
        Schedules the delivery of a daily local notification.
     
        - Parameters:

            - identifier: A unique value to identify the notification's request. If left empty receives a string created from an UUID.
     
            - title: The localized text that provides the notification’s primary description.
     
            - subtitle: The localized text that provides the notification’s secondary description.
     
            - body: The localized text that provides the notification’s main content.
     
            - sound: The sound that plays when the system delivers the notification.
     
            - hour: The hour when the daily notification will fire.
     
            - minute: The minute when the daily notification will fire.
     
            - second: The second when the daily notification will fire.
     
            - repeats: A Boolean value indicating whether the system reschedules the notification after it’s delivered.
     
        This method schedules local notifications only; you cannot use it to schedule the delivery of remote notifications. Upon calling this method, it creates a trigger to display at 17:30 repeating everyday, then the system begins tracking the trigger conditions associated with your request. When the trigger condition is met, the system delivers your notification.
     
        ````swift
        // Scheduling a local notification to fire everyday at 17:30
        let manager = NotificationManager.shared
        manager.scheduleTimeIntervalNotification(
            title: "Daily Notification",
            body: "This notification triggers everyday",
            hour: 17
            minute: 30
        )
        ````
    */
    public func scheduleDailyNotification(identifier: String = UUID().uuidString, title: String, subtitle: String = "", body: String, sound: UNNotificationSound = UNNotificationSound.default, hour: Int, minute: Int? = 0, second: Int? = 0, repeats: Bool = true) {
        let content = setupContent(title: title, subtitle: subtitle, body: body, sound: sound)
        
        var date = DateComponents()
        date.hour = hour
        date.minute = minute
        date.second = second
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: repeats)
        
        scheduleNotification(identifier: identifier, content: content, trigger: trigger)
    }
    
    /**
        Schedules the delivery of a local notification with a Location trigger.
     
        - Parameters:

            - identifier: A unique value to identify the notification's request. If left empty receives a string created from an UUID.
     
            - title: The localized text that provides the notification’s primary description.
     
            - subtitle: The localized text that provides the notification’s secondary description.
     
            - body: The localized text that provides the notification’s main content.
     
            - latitude: The center's latitude of the area desired.
     
            - longitude: The center's longitude of the area desired.
     
            - radius: The radius of the area desired.
     
            - placeID: A unique value to identify the area desired.
     
            - notifyOnEntry: A Boolean value indicating if the notification will fire on entry of the area or not.
     
            - notifyOnExit: A Boolean value indicating if the notification will fire on exit of the area or not.
     
            - repeats: A Boolean value indicating whether the system reschedules the notification after it’s delivered.
     
        This method schedules local notifications only; you cannot use it to schedule the delivery of remote notifications. Upon calling this method, it creates a region with the latitude, longitude and radius values and it creates a trigger that displays when entering or exit of the area, then the system begins tracking the trigger conditions associated with your request. When the trigger condition is met, the system delivers your notification.
     
        ````swift
        // Scheduling a local notification to fire on entry of Chapada dos Guimarães
        let manager = NotificationManager.shared
        manager.scheduleTimeIntervalNotification(
            title: "Chapada dos Guimarães",
            body: "This notification triggers when entering Chapada dos Guimarães",
            latitude: -15.4528
            longitude: -55.7392
            radius: 2500
            placeID: "Chapada dos Guimarães"
        )
        ````
    */
    public func scheduleLocationNotification(identifier: String = UUID().uuidString, title: String, subtitle: String = "", body: String, sound: UNNotificationSound? = UNNotificationSound.default, latitude: Double, longitude: Double, radius: Double = 2000.0, placeID: String, notifyOnEntry: Bool = true, notifyOnExit: Bool = false, repeats: Bool) {
        let content = setupContent(title: title, subtitle: subtitle, body: body, sound: sound)
        let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = CLCircularRegion(center: center, radius: radius, identifier: placeID)
        
        region.notifyOnEntry = notifyOnEntry
        region.notifyOnExit = notifyOnExit
        
        let trigger = UNLocationNotificationTrigger(region: region, repeats: repeats)
        
        scheduleNotification(identifier: identifier, content: content, trigger: trigger)
    }
    
    /**
        Removes all of your app’s pending local notifications.
    */
    public func cancelAllPendingNotifications() {
        center.removeAllPendingNotificationRequests()
    }
    
    /**
        Removes your app’s local notifications that are pending and match the specified identifiers.
     
        - Parameters:

            - identifier: A unique value to identify the notification's request.
    */
    public func cancelPendingNotification(identifier: String) {
        center.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
}
