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
    
    static func reminderDate(for type: MealType) -> DateComponents {
        switch type {
        case .breakfast:
            return DateComponents(hour: 9)
        case .lunch:
            return DateComponents(hour: 13)
        case .dinner:
            return DateComponents(hour: 19)
        default:
            return DateComponents(hour: 22)
        }
    }
}
