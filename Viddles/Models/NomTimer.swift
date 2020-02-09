//
//  Timer.swift
//  Viddles
//
//  Created by Michael Critz on 2/4/20.
//  Copyright © 2020 pixel.science. All rights reserved.
//

import Combine
import Foundation

final class NomTimer {
    
    let timerPublisher = Timer.TimerPublisher(interval: 1,
                                              runLoop: .main,
                                              mode: .default)
    let cancellable: AnyCancellable?
    
    init() {
        self.cancellable = timerPublisher.connect() as? AnyCancellable
    }
    
    deinit {
        self.cancellable?.cancel()
    }
}

extension NomTimer {
    
    static func runTimer(interval: TimeInterval = 60, repeats: Bool = true, with block: @escaping (() -> ()) ) {
        let timer = Timer(timeInterval: interval, repeats: repeats) { timer in
            block()
        }
        timer.fire()
    }
    
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
