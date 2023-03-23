//
//  MealQuality.swift
//  Viddles
//
//  Created by Michael Critz on 7/31/22.
//  Copyright © 2022 pixel.science. All rights reserved.
//

import Foundation

@objc(MealQuality)
public enum MealQuality: Int16, CustomStringConvertible {
    case unknown = -1
    case healthy = 1
    case moderated = 2
    case heavy = 3
    case ultra = 4
    
    public var description: String {
        switch self {
        case .healthy:
            return "Healthy"
        case .moderated:
            return "Moderated"
        case .heavy:
            return "Chow Down"
        case .ultra:
            return "Food Fiesta"
        default:
            return "Unknown"
        }
    }
}
