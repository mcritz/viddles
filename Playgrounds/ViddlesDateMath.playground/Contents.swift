import UIKit

let seconds = -86500.0
seconds / (60 * 60 * 24)

let oldDate = Date(timeInterval: seconds, since: Date())

//var components: Set<Calendar.Component> = [Calendar.Component.day]

let difference = Calendar(identifier: .iso8601).dateComponents([Calendar.Component.day], from: Date(), to: oldDate)

let todayComponents = Calendar(identifier: .iso8601).dateComponents([.day, .month, .year], from: Date())

let thisDay = Calendar(identifier: .iso8601).date(from: todayComponents)
