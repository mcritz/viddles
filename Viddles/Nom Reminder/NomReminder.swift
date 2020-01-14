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
    let title: String
    let message: String
    let attachmentURL: URL? = Bundle.main.url(forResource: "RoundFace", withExtension: "pdf")
}
