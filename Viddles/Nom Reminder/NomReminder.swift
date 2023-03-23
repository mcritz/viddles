//
//  NomReminder.swift
//  Viddles
//
//  Created by Michael Critz on 12/30/19.
//  Copyright © 2019 pixel.science. All rights reserved.
//

import Foundation

struct NomReminder: Codable {
    internal init(id: UUID = UUID(), type: MealType, reminderHours: DateComponents, repeats: Bool, title: String, attachmentURL: URL? = nil, message: String) {
        self.id = id
        self.type = type
        self.reminderHours = reminderHours
        self.repeats = repeats
        self.title = title
        self.attachmentURL = attachmentURL
        self.message = message
    }
    
    let id: UUID
    let type: MealType
    let reminderHours: DateComponents
    let repeats: Bool
    let title: String
    let attachmentURL: URL?
    let message: String
}
