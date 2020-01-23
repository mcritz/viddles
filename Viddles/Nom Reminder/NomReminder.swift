//
//  NomReminder.swift
//  Viddles
//
//  Created by Michael Critz on 12/30/19.
//  Copyright © 2019 pixel.science. All rights reserved.
//

import Foundation

struct NomReminder: Codable {
    let id = UUID()
    let type: MealType
    let reminderHours: DateComponents
    let repeats: Bool
    let title: String
    let attachmentURL: URL?
    let message: String
}
