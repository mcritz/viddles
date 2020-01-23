//
//  NomReminderController.swift
//  Viddles
//
//  Created by Michael Critz on 12/30/19.
//  Copyright © 2019 pixel.science. All rights reserved.
//

import UIKit
import Combine

enum NotificationCategory: String {
    case action = "eat.action"
}

class NomReminderController: ObservableObject {
    @Published var reminderStatus = ReminderStatus.unauthorized
    private let nomReminders: [NomReminder]
    private let statusSubject = CurrentValueSubject<ReminderStatus, Never>(.pending)
    private var subscriptions = Set<AnyCancellable>()
    private let nomNowAction: UNNotificationAction
    private let nomCategory: UNNotificationCategory
    
    /// Adds notifications to UNNotificationCenter
    /// - Parameter nomReminder: model to populate notification
    func schedule(nomReminder: NomReminder) {
        let notification = UNMutableNotificationContent()
        notification.title = nomReminder.title
        notification.body = nomReminder.message
        if let realURL = nomReminder.attachmentURL {
            if let attachment = try? UNNotificationAttachment(identifier:
                                         "image",
                                                              url: realURL,
                                                              options: nil) {
               notification.attachments = [attachment]
            }
        }
        notification.categoryIdentifier = NotificationCategory.action.rawValue
        let trigger = UNCalendarNotificationTrigger(dateMatching: nomReminder.reminderHours,
                                                    repeats: true)
        let request = UNNotificationRequest(identifier: nomReminder.id.uuidString,
                                    content: notification,
                                    trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (err) in
            if let realError = err {
                self.statusSubject.send(.error)
                print(realError.localizedDescription)
                return
            }
        }
    }
    
    /// Toggle notifications
    func toggleReminders() {
        // Hold permissions if we have them, but disable notifications
        if reminderStatus == .authorized {
            self.statusSubject.send(.disabled)
            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            UserDefaults.standard.set(false, forKey: "RemindersEnabled")
            return
        }
        
        // User requests reminders
        statusSubject.send(.pending)
        
        checkNotificationPermissions { status in
            guard status == .authorized else {
                self.requestNotificationsAuthorization {
                    self.scheduleReminders()
                }
                return
            }
            self.scheduleReminders()
        }
    }
    
    /// Requests this object’s reminders and saves preferenes
    private func scheduleReminders() {
        self.nomReminders.forEach { reminder in
            schedule(nomReminder: reminder)
        }
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { requests in
            print("Notifs Requests:", requests.count)
        })
        save()
    }
    
    /// Checks notification permissions
    /// - Parameter completion: handler
    func checkNotificationPermissions(completion: @escaping (ReminderStatus) -> ()) {
        let remindersEnabled = UserDefaults.standard.bool(forKey: "RemindersEnabled")
        guard remindersEnabled else {
            self.statusSubject.send(.disabled)
            completion(.disabled)
            return
        }
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .denied:
                self.statusSubject.send(.unauthorized)
                completion(.unauthorized)
            case .notDetermined:
                self.statusSubject.send(.pending)
                completion(.pending)
            default:
                self.statusSubject.send(.authorized)
                completion(.authorized)
            }
        }
    }
    
    /// Uses `UserDefaults` to save the user’s choice for showing reminders and all scheduled reminder IDs
    private func save() {
        for type in MealType.allTypes {
            UserDefaults.standard.removeObject(forKey: type.description)
        }
        for reminder in nomReminders {
            UserDefaults.standard.setValue(reminder.id.uuidString,
                                           forKey: reminder.type.description)
        }
        UserDefaults.standard.set(true, forKey: "RemindersEnabled")
        print("Reminders scheduled")
    }
    
    /// Requests notifications
    /// - Parameter completion: handler
    func requestNotificationsAuthorization(completion: @escaping () -> ()) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let realError = error {
                print(realError.localizedDescription)
                self.statusSubject.send(.error)
                completion()
                return
            }
            if !granted,
            let appSettings = URL(string: UIApplication.openSettingsURLString) {
                DispatchQueue.main.async {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                    completion()
                }
                return
            }
            if !granted {
                self.statusSubject.send(.unauthorized)
                completion()
                return
            }
            self.statusSubject.send(.authorized)
            completion()
        }
    }
    
    init() {
        nomNowAction = UNNotificationAction(
            identifier: "nom.now",
            title: "Nom",
            options: []
        )
        nomCategory = UNNotificationCategory(
            identifier: NotificationCategory.action.rawValue,
            actions: [nomNowAction],
            intentIdentifiers: [],
            options: []
        )
        UNUserNotificationCenter.current().setNotificationCategories([nomCategory])
        nomReminders = [
            MealType.breakfast,
            MealType.lunch,
            MealType.dinner
        ].map { type in
            let imageURL = Bundle.main.url(forResource: "RoundFace", withExtension: "jpg")
            return NomReminder(type: type,
                               reminderHours: Nom.reminderDate(for: type),
                               repeats: true,
                               title: type.description,
                               attachmentURL: imageURL,
                               message: NSLocalizedString("Did you eat?", comment: ""))
        }
        
        _ = self.statusSubject
            .subscribe(on: DispatchQueue.main)
            .sink { (newStatus) in
                print("NotificationStatus:", newStatus)
                DispatchQueue.main.async {
                    self.reminderStatus = newStatus
                }
        }.store(in: &subscriptions)
        
        let remindersEnabled = UserDefaults.standard.bool(forKey: "RemindersEnabled")
        if !remindersEnabled {
            reminderStatus = .disabled
            return
        }
    }
}

/**
 ReminderStatus State Machine
                                                                (On user prompt)
        ┌───────────────────────────────────────────────────────────────────────┐
        ▼                                                                       │
 ┌─────────────┐                      Λ                          Λ     ┌────────────────┐
 │             │   ┌─────────────────╱ ╲      ┌─────────────────╱ ╲    │                │
 │  .pending   │───▶     ERROR?     ▕   ──NO──▶ IS AUTHORIZED? ▕   ─NO─▶ .unauthorized  |
 │             │   └─────────────────╲ ╱      └─────────────────╲ ╱    │                │
 └─────────────┘                      │                          │     └────────────────┘
        ▲                          YES │                      YES │
        │                          ┌───▼───┐               ┌──────▼─────┐        ┌────────────┐
        │                          │       │               │            │        │            │
        └──────────────────────────│.error │               │ .authorized│        │ .disabled  │
                  ( On user prompt) │       │               │            ◀────────▶            │
                                      └───────┘               └────────────┘        └────────────┘
                                                                    (On user prompt)
*/
public enum ReminderStatus {
    case pending, error, unauthorized, authorized, disabled
}
