//
//  NomReminderController.swift
//  Viddles
//
//  Created by Michael Critz on 12/30/19.
//  Copyright © 2019 pixel.science. All rights reserved.
//

import UIKit

class NomReminderController {
    let nomReminders: [NomReminder]
    let center = UNUserNotificationCenter.current()
    
    func createReminders() {
        nomReminders.forEach { reminder in
            let notification = UNMutableNotificationContent()
            notification.title = reminder.title
            notification.body = reminder.message
            let trigger = UNCalendarNotificationTrigger(dateMatching: reminder.reminderHours, repeats: true)
            let request = UNNotificationRequest(identifier: reminder.id.uuidString,
                                        content: notification,
                                        trigger: trigger)
            center.add(request) { (err) in
                if let realError = err {
                    print(realError.localizedDescription)
                }
            }
        }
    }
    
    func checkNotificationPermissions(completion: @escaping (Bool) -> Void) {
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func requestNotifications(completion: @escaping (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let realError = error {
                print(realError.localizedDescription)
                completion(false)
                return
            }
            if !granted {
                print("User did not grant permissions")
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    init() {
        nomReminders = [
            MealType.breakfast,
            MealType.lunch,
            MealType.dinner
        ].map { type in
            return NomReminder(type: type,
                               reminderHours: NomReminder.reminderDate(for: type),
                               title: type.description,
                               message: NSLocalizedString("Time to log your noms", comment: "")
            )
        }
        checkNotificationPermissions(completion: { isAuthorized in
            if !isAuthorized {
                self.requestNotifications { (didAuthorize) in
                    if !didAuthorize {
                        return
                    }
                }
            }
        })
    }
}
