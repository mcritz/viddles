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
    @NSManaged public var noms: Set<Nom>
    @NSManaged public var mealDay: Set<MealDay>?
    
    override public var description: String {
        get {
            let mealName = self.type?.capitalized(with: Locale.current) ?? "Noms"
            guard let createdAt = createdAt else { return mealName }
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            return mealName + " @ " + formatter.string(from: createdAt)
        }
    }
}

extension Meal {
    static func getAllMeals() -> NSFetchRequest<Meal> {
        return Meal.fetchRequest() as! NSFetchRequest<Meal>
    }
}

extension Meal {
    @objc(addNomsObject:)
    @NSManaged public func addToNoms(_ value: Nom)
    
    @objc(removeNomsObject:)
    @NSManaged public func removeFromNoms(_ value: Nom)
}

extension Meal {
    static func new(in context: NSManagedObjectContext, with nom: Nom?) -> Meal {
        let newMeal = Meal(context: context)
        newMeal.setValue(UUID(), forKey: #keyPath(Meal.id))
        newMeal.setValue(MealType.getCurrent().rawValue, forKey: #keyPath(Meal.type))
        newMeal.setValue(Date(), forKey: #keyPath(Meal.createdAt))
        if let realNom = nom {
            newMeal.addToNoms(realNom)
        }
        return newMeal
    }
    
    public func vomit() {
        guard let realNom = noms.randomElement() else { return }
        managedObjectContext?.delete(realNom)
        if noms.count < 1 {
            managedObjectContext?.delete(self)
        }
        try? managedObjectContext?.save()
    }
}
