//
//  MealDay.swift
//  Viddles
//
//  Created by Michael Critz on 12/22/19.
//  Copyright © 2019 pixel.science. All rights reserved.
//

import CoreData

public class MealDay: NSManagedObject {
    @NSManaged var id: UUID?
    @NSManaged var createdAt: Date?
    @NSManaged var meals: NSSet?
    
    override public var description: String {
        return DateFormatter().string(from: Date())
    }
}

extension MealDay {
    static func getAllMealDays() -> NSFetchRequest<MealDay> {
        let request = MealDay.fetchRequest() as! NSFetchRequest<MealDay>
        let sorter = NSSortDescriptor(key: #keyPath(MealDay.createdAt), ascending: false)
        request.sortDescriptors = [sorter]
        return request
    }
    
    @objc(addToMealsObject:)
    @NSManaged public func addToMeals(_ value: Meal)
    
    @objc(removeFromMealsObject:)
    @NSManaged public func removeFromMeals(_ value: Meal)
}

extension MealDay {
    static func newDay(context: NSManagedObjectContext) {
        let newDay = MealDay(context: context)
        newDay.setValue(UUID(), forKey: #keyPath(MealDay.id))
        newDay.setValue(Date(), forKey: #keyPath(MealDay.createdAt))
        context.insert(newDay)
        try? context.save()
    }
    
    
    public func eat() {
        
        guard let context = self.managedObjectContext else { return }
        
        let type = MealType.getCurrent()
        let currentMeal = meals?.filter{ element -> Bool in
            guard let meal = element as? Meal else { return false }
            return meal.type == type.rawValue
        }
        if let matchedMeal = currentMeal?.first as? Meal {
            matchedMeal.addToNoms(Nom.newNom())
        } else {
            let newMeal = Meal.new(in: context, with: Nom.newNom())
            self.addToMeals(newMeal)
        }
        try? self.managedObjectContext?.save()
    }
}
