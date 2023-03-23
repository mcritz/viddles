//
//  Meal.swift
//  Viddles
//
//  Created by Michael Critz on 12/21/19.
//  Copyright © 2019 pixel.science. All rights reserved.
//

import CoreData

public class Meal: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var type: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var mealDay: Set<MealDay>?
    @NSManaged private var quality: Int16
    public var mealQuality: MealQuality {
        set {
            self.quality = newValue.rawValue
        }
        get {
            MealQuality(rawValue: quality) ?? .unknown
        }
    }
    
    override public var description: String {
        get {
            return self.type?.capitalized(with: Locale.current) ?? "Noms"
        }
    }
    
    var formattedDate: String {
        guard let createdAt = createdAt else { return "—" }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: createdAt)
    }
}

extension Meal {
    static func getAllMeals() -> NSFetchRequest<Meal> {
        let request = Meal.fetchRequest() as! NSFetchRequest<Meal>
        let sorter = NSSortDescriptor(key: #keyPath(Meal.createdAt), ascending: false)
        request.sortDescriptors = [sorter]
        return request
    }
}

extension Meal {
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
