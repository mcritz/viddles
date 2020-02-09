//
//  Timer.swift
//  Viddles
//
//  Created by Michael Critz on 2/4/20.
//  Copyright © 2020 pixel.science. All rights reserved.
//

import Foundation

final class NomTimer {
    
    private func nominallyEnglish(_ number: Int?, comp: Calendar.Component) -> String {
        guard let number = number else { return "" }
        switch number {
        case 0:
            return ""
        case 1:
            return "\(number) \(comp) "
        default:
            return "\(number) \(comp)s "
        }
    }
    
    func description(of components: DateComponents) -> String {
        var description = ""
        let days = nominallyEnglish(components.day, comp: .day)
        description.append(days)
        let hours = nominallyEnglish(components.hour, comp: .hour)
        description.append(hours)
        let minutes = nominallyEnglish(components.minute, comp: .minute)
        description.append(minutes)
        return description
    }
    
    private func describeFuture(_ date: Date?) -> String {
        return NSLocalizedString("in the future ", comment: "")
    }
    
    func timeSince(date: Date) -> String {
        if date > Date() {
            return describeFuture(date)
        }
        let components = Calendar(identifier: .iso8601)
            .dateComponents([.day, .hour, .minute, .second], from: date, to: Date())
        let timeString = description(of: components)
        return "\(timeString)"
    }
}
