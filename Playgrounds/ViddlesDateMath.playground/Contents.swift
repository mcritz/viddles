import UIKit

let seconds = -86500.0
seconds / (60 * 60 * 24)

let oldDate = Date(timeInterval: seconds, since: Date())

//var components: Set<Calendar.Component> = [Calendar.Component.day]

let difference = Calendar(identifier: .iso8601).dateComponents([Calendar.Component.day], from: Date(), to: oldDate)

var todayComponents = Calendar(identifier: .iso8601).dateComponents([.day, .month, .year], from: Date())

todayComponents.hour = 9

let thisDay = Calendar(identifier: .iso8601).date(from: todayComponents)
let otherDay = Calendar(identifier: .iso8601).date(bySetting: .hour, value: 23, of: thisDay!)


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
    
    func timeSince(date: Date) -> String {
        let components = Calendar(identifier: .iso8601)
            .dateComponents([.day, .hour, .minute], from: date, to: Date())
        let timeString = description(of: components)
        
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        formatter.doesRelativeDateFormatting = true
        let sinceString = formatter.string(from: date)
        return "\(timeString) since \(sinceString)"
    }
}

NomTimer().timeSince(date: Date().addingTimeInterval(-123_239))
