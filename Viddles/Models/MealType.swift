//
//  MealType.swift
//  Viddles
//
//  Created by Michael Critz on 12/22/19.
//  Copyright © 2019 pixel.science. All rights reserved.
//

import Foundation

enum MealType: String, Codable, CustomStringConvertible, CaseIterable {
    case snack, breakfast, lunch, dinner, midnight
    var description: String {
        get {
            return self.rawValue.capitalized(with: Locale.current)
        }
    }
    
    static func getCurrent() -> MealType {
        let hour = Calendar.current.component(.hour, from: Date())
        var type: MealType
        switch hour {
        case 1...5:
            type = .midnight
        case 6...9:
            type = .breakfast
        case 11...13:
            type = .lunch
        case 17...20:
            type = .dinner
        case 22...24:
            type = .midnight
        default:
            type = .snack
        }
        return type
    }
}
