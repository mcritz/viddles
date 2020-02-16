//
//  Nom.swift
//  Viddles
//
//  Created by Michael Critz on 12/21/19.
//  Copyright © 2019 pixel.science. All rights reserved.
//

import CoreData

enum NomType: String {
    case orange, green, blue, red, hydro
}

public class Nom: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var createdAt: Date?
    @NSManaged public var value: Int
    @NSManaged public var type : String?
    @NSManaged public var meal: Set<Meal>?
}

extension Nom {
    static func getAllNoms() -> NSFetchRequest<Nom> {
        let request = Nom.fetchRequest() as! NSFetchRequest<Nom>
        let sorter = NSSortDescriptor(key: #keyPath(Nom.createdAt), ascending: false)
        request.sortDescriptors = [sorter]
        return request
    }
    
    static func newNom(context: NSManagedObjectContext, date: Date? = Date()) -> Nom {
        let newNom = Nom(context: context)
        newNom.setValue(UUID(), forKey: #keyPath(Nom.id))
        newNom.setValue(date, forKey: #keyPath(Nom.createdAt))
        newNom.setValue(150, forKey: #keyPath(Nom.value))
        newNom.setValue(Nom.randomType(), forKey: #keyPath(Nom.type))
        return newNom
    }
    
    static func randomType() -> String {
        return [
            "RoundFace",
            "BlueFace",
            "RedFace",
            "GreenFace"
            ].randomElement()!
    }
}

extension Nom {
    
    func imageName() -> String {
        guard let name = self.type else {
            return "RoundFace"
        }
        return name
    }
}


extension Nom {
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
    
    /// Returns an approximate Date for a meal, or Date()
    /// - Parameter type: MealType
    static func nominalDate(for type: MealType, on date: Date?) -> Date {
        guard let hourValue = Nom.reminderDate(for: type).hour else {
            return Date()
        }
        var targetDate: Date = Date()
        if let realDate = date {
            targetDate = realDate
        }
        var components = Calendar(identifier: .iso8601)
            .dateComponents([.day, .month, .year, .timeZone], from: targetDate)
        components.hour = hourValue
        guard let nominal = Calendar(identifier: .iso8601)
            .date(from: components) else {
                    return Date()
        }
        print("Nominal", nominal)
        return nominal
    }
}
