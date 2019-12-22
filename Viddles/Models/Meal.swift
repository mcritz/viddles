//
//  Meal.swift
//  Viddles
//
//  Created by Michael Critz on 12/21/19.
//  Copyright © 2019 pixel.science. All rights reserved.
//

import CoreData

public class Meal: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var type: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var noms: NSSet?
    @NSManaged public var mealDay: NSSet?
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
}
