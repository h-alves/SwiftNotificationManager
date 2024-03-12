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
}
