//
//  NomNotificationCenterDelegate.swift
//  Viddles
//
//  Created by Michael Critz on 1/20/20.
//  Copyright © 2020 pixel.science. All rights reserved.
//

import UserNotifications

class NomNotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("BINGO!", response)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("INCOMING!", notification)
        completionHandler([.sound])
    }
}
