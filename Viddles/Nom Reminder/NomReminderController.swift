//
//  NomReminderController.swift
//  Viddles
//
//  Created by Michael Critz on 12/30/19.
//  Copyright © 2019 pixel.science. All rights reserved.
//

import UIKit
import Combine

class NomReminderController: ObservableObject {
    @Published var reminderStatus = ReminderStatus.unauthorized
    private let nomReminders: [NomReminder]
    private let center = UNUserNotificationCenter.current()
    private let statusSubject = CurrentValueSubject<ReminderStatus, Never>(.pending)
    private var subscriptions = Set<AnyCancellable>()
    
    func toggleReminders() {
        // Hold permissions if we have them, but disable notifications
        if reminderStatus == .authorized {
            self.statusSubject.send(.disabled)
            center.removeAllDeliveredNotifications()
            center.removeAllPendingNotificationRequests()
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
    
    private func scheduleReminders() {
        self.nomReminders.forEach { reminder in
            let notification = UNMutableNotificationContent()
            notification.title = reminder.title
            notification.body = reminder.message
            if let realURL = reminder.attachmentURL {
                if let attachment = try? UNNotificationAttachment(identifier:
                                             "image",
                                                                  url: realURL,
                                                                  options: nil) {
                   notification.attachments = [attachment]
                }
            }
            let trigger = UNCalendarNotificationTrigger(dateMatching: reminder.reminderHours,
                                                        repeats: true)
            let request = UNNotificationRequest(identifier: reminder.id.uuidString,
                                        content: notification,
                                        trigger: trigger)
            self.center.add(request) { (err) in
                if let realError = err {
                    self.statusSubject.send(.error)
                    print(realError.localizedDescription)
                    return
                }
            }
        }
        center.getPendingNotificationRequests(completionHandler: { requests in
            print("Notifs Requests:", requests)
        })
        save()
    }
    
    func checkNotificationPermissions(completion: @escaping (ReminderStatus) -> ()) {
        let remindersEnabled = UserDefaults.standard.bool(forKey: "RemindersEnabled")
        guard remindersEnabled else {
            self.statusSubject.send(.disabled)
            completion(.disabled)
            return
        }
        center.getNotificationSettings { settings in
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
    
    func requestNotificationsAuthorization(completion: @escaping () -> ()) {
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
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
        nomReminders = [
            MealType.breakfast,
            MealType.lunch,
            MealType.dinner
        ].map { type in
            return NomReminder(type: type,
                                reminderHours: Nom.reminderDate(for: type),
                                title: type.description,
                                message: NSLocalizedString("Time to log your noms", comment: "")
            )
        }
        
        _ = self.statusSubject
            .subscribe(on: DispatchQueue.main)
            .sink { (newStatus) in
                print("New Status:", newStatus)
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
                  ( On user prompt)│       │               │            ◀────────▶            │
                                   └───────┘               └────────────┘        └────────────┘
                                                                    (On user prompt)
*/
public enum ReminderStatus {
    case pending, error, unauthorized, authorized, disabled
}
