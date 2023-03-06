//
//  NotificationManager.swift
//  Crossfit Diary
//
//  Created by Kim TaeSoo on 2023/02/14.
//

import Foundation
import UserNotifications

class NotificationManager {
    private let notificationCenter = UNUserNotificationCenter.current()

    static let shared = NotificationManager()
    private init() {}
    
    func requestNotificationAuth(completionHandler: @escaping (Error?) -> ()) {
        let authOptions: UNAuthorizationOptions = UNAuthorizationOptions(arrayLiteral: .badge, .alert, .sound)
        notificationCenter.requestAuthorization(options: authOptions) { [unowned self] success, error in
            if success {
                self.sendNoti() {
                    completionHandler($0)
                }
            }
        }
    }
    
    func sendNoti(completionHandler: @escaping (Error?) -> ()) {
        notificationCenter.removeAllPendingNotificationRequests()
        let content = UNMutableNotificationContent()
        content.title = "와디"
        content.subtitle = "오늘 운동하셨나요?"
        var dateComponents = DateComponents()
        dateComponents.hour = 22
        dateComponents.minute = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        notificationCenter.add(request) { (error) in
            if error != nil {
                completionHandler(error)
            }
        }
    }
}
